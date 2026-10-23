package com.example.buggie

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock
import android.provider.Settings
import android.view.Gravity
import android.view.WindowManager
import android.widget.ImageView
import kotlin.math.PI
import kotlin.math.abs
import kotlin.math.atan2
import kotlin.math.cos
import kotlin.math.sin
import kotlin.random.Random

class OverlayService : Service() {

    // 애벌레 한 마리의 정보 (화면, 위치, 이동 방향, 프레임 번호)
    private class Bug(
        val frames: IntArray,
        val view: ImageView,
        val params: WindowManager.LayoutParams,
        val speed: Float,
        var x: Float,
        var y: Float,
        var angle: Float,
        var targetAngle: Float,
        var nextTurnAt: Long,
        var facingRight: Boolean,
        var framePosition: Int
    )

    private lateinit var windowManager: WindowManager
    private val bugs = mutableListOf<Bug>()
    private val handler = Handler(Looper.getMainLooper())

    private val greenFrames = intArrayOf(
        R.drawable.bug_frame_1,
        R.drawable.bug_frame_2,
        R.drawable.bug_frame_3,
        R.drawable.bug_frame_4,
        R.drawable.bug_frame_3,
        R.drawable.bug_frame_2
    )

    private val secondFrames = intArrayOf(
        R.drawable.bug_frame2_1,
        R.drawable.bug_frame2_2,
        R.drawable.bug_frame2_3,
        R.drawable.bug_frame2_4,
        R.drawable.bug_frame2_3,
        R.drawable.bug_frame2_2
    )

    private val animationRunnable = object : Runnable {
        override fun run() {
            if (bugs.isEmpty()) return

            for (bug in bugs) {
                bug.framePosition = (bug.framePosition + 1) % bug.frames.size
                bug.view.setImageResource(bug.frames[bug.framePosition])
            }

            handler.postDelayed(this, FRAME_DELAY_MS)
        }
    }

    private val movementRunnable = object : Runnable {
        override fun run() {
            if (bugs.isEmpty()) return

            val screenWidth = resources.displayMetrics.widthPixels
            val screenHeight = resources.displayMetrics.heightPixels
            val now = SystemClock.uptimeMillis()

            for (bug in bugs) {
                val maxX = (screenWidth - bug.params.width)
                    .coerceAtLeast(0).toFloat()
                val maxY = (screenHeight - bug.params.height - dpToPx(48))
                    .coerceAtLeast(0).toFloat()

                // 1) 가끔 가고 싶은 방향을 조금 바꿔요
                if (now >= bug.nextTurnAt) {
                    bug.targetAngle =
                        bug.angle + randomRange(-TURN_RANGE, TURN_RANGE)
                    bug.nextTurnAt =
                        now + Random.nextLong(TURN_MIN_MS, TURN_MAX_MS)
                }

                // 2) 벽에 가까워지면 화면 안쪽을 향하도록 방향을 정해요
                val marginX = maxX * EDGE_MARGIN
                val marginY = maxY * EDGE_MARGIN
                var pushX = 0f
                var pushY = 0f
                if (bug.x < marginX) pushX += 1f
                if (bug.x > maxX - marginX) pushX -= 1f
                if (bug.y < marginY) pushY += 1f
                if (bug.y > maxY - marginY) pushY -= 1f
                if (pushX != 0f || pushY != 0f) {
                    bug.targetAngle = atan2(pushY, pushX)
                }

                // 3) 현재 방향을 목표 방향으로 서서히 돌려요
                val diff = normalizeAngle(bug.targetAngle - bug.angle)
                val turn = (diff * TURN_EASE)
                    .coerceIn(-MAX_TURN_PER_TICK, MAX_TURN_PER_TICK)
                bug.angle = normalizeAngle(bug.angle + turn)

                // 4) 앞으로 이동 (위아래는 조금 덜 움직이게 해요)
                val dirX = cos(bug.angle)
                val dirY = sin(bug.angle)
                bug.x += dirX * bug.speed
                bug.y += dirY * bug.speed * VERTICAL_RATIO

                // 안전장치: 화면 밖으로 나가지 않게만 막아요
                bug.x = bug.x.coerceIn(0f, maxX)
                bug.y = bug.y.coerceIn(0f, maxY)

                // 5) 이미지 방향 (거의 위아래로 갈 때는 그대로 둬요)
                if (dirX > FLIP_THRESHOLD && !bug.facingRight) {
                    bug.facingRight = true
                    bug.view.scaleX = 1f
                } else if (dirX < -FLIP_THRESHOLD && bug.facingRight) {
                    bug.facingRight = false
                    bug.view.scaleX = -1f
                }

                bug.params.x = bug.x.toInt()
                bug.params.y = bug.y.toInt()

                try {
                    windowManager.updateViewLayout(bug.view, bug.params)
                } catch (_: Exception) {
                }
            }

            handler.postDelayed(this, 16)
        }
    }

    override fun onCreate() {
        super.onCreate()

        createNotificationChannel()
        startForeground(1001, createNotification())

        windowManager =
            getSystemService(WINDOW_SERVICE) as WindowManager
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {
        if (!hasOverlayPermission()) {
            stopSelf()
            return START_NOT_STICKY
        }

        if (bugs.isEmpty()) {
            showBugs()
        }

        return START_STICKY
    }

    private fun showBugs() {
        val size = dpToPx(170)
        val screenWidth = resources.displayMetrics.widthPixels
        val screenHeight = resources.displayMetrics.heightPixels

        val maxX = (screenWidth - size).coerceAtLeast(0).toFloat()
        val maxY = (screenHeight - size - dpToPx(48))
            .coerceAtLeast(0).toFloat()

        // 초록 애벌레: 왼쪽 위쪽에서 시작, 오른쪽 아래로 천천히 이동
        addBug(
            frames = greenFrames,
            size = size,
            speed = GREEN_SPEED,
            startX = maxX * 0.05f,
            startY = maxY * 0.2f,
            startAngle = 0.4f,
            startFrame = 0
        )

        // 두 번째 애벌레: 오른쪽 아래쪽에서 시작, 왼쪽 위로 천천히 이동
        addBug(
            frames = secondFrames,
            size = size,
            speed = SECOND_SPEED,
            startX = maxX * 0.95f,
            startY = maxY * 0.7f,
            startAngle = (PI - 0.4).toFloat(),
            startFrame = 2
        )

        handler.post(animationRunnable)
        handler.post(movementRunnable)
    }

    private fun addBug(
        frames: IntArray,
        size: Int,
        speed: Float,
        startX: Float,
        startY: Float,
        startAngle: Float,
        startFrame: Int
    ) {
        val facingRight = cos(startAngle) >= 0f

        val view = ImageView(this).apply {
            setImageResource(frames[startFrame])
            scaleType = ImageView.ScaleType.CENTER_INSIDE
            scaleX = if (facingRight) 1f else -1f
        }

        val windowType =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                WindowManager.LayoutParams.TYPE_PHONE
            }

        val params = WindowManager.LayoutParams(
            size,
            size,
            windowType,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = startX.toInt()
            y = startY.toInt()
        }

        windowManager.addView(view, params)

        bugs.add(
            Bug(
                frames = frames,
                view = view,
                params = params,
                speed = speed,
                x = startX,
                y = startY,
                angle = startAngle,
                targetAngle = startAngle,
                nextTurnAt = SystemClock.uptimeMillis() +
                        Random.nextLong(TURN_MIN_MS, TURN_MAX_MS),
                facingRight = facingRight,
                framePosition = startFrame
            )
        )
    }

    private fun randomRange(min: Float, max: Float): Float {
        return min + Random.nextFloat() * (max - min)
    }

    // 각도를 -180도 ~ 180도 사이로 맞춰요
    private fun normalizeAngle(value: Float): Float {
        var result = value
        val twoPi = (2 * PI).toFloat()
        while (result > PI) result -= twoPi
        while (result < -PI) result += twoPi
        return result
    }

    override fun onDestroy() {
        handler.removeCallbacks(animationRunnable)
        handler.removeCallbacks(movementRunnable)

        for (bug in bugs) {
            try {
                windowManager.removeView(bug.view)
            } catch (_: Exception) {
            }
        }
        bugs.clear()

        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun hasOverlayPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                Settings.canDrawOverlays(this)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Buggie 애벌레",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager =
                getSystemService(NotificationManager::class.java)

            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val builder =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Notification.Builder(this, CHANNEL_ID)
            } else {
                Notification.Builder(this)
            }

        return builder
            .setContentTitle("Buggie 실행 중")
            .setContentText("애벌레가 화면 위에서 움직이고 있어요.")
            .setSmallIcon(android.R.drawable.ic_menu_view)
            .setOngoing(true)
            .build()
    }

    private fun dpToPx(dp: Int): Int {
        return (dp * resources.displayMetrics.density).toInt()
    }

    companion object {
        private const val CHANNEL_ID = "buggie_overlay"

        // 이동 속도 (원래는 4였어요). 숫자를 줄이면 더 느려져요.
        private const val GREEN_SPEED = 3.0f
        private const val SECOND_SPEED = 2.7f

        // 프레임 바뀌는 간격 (밀리초). 숫자를 키우면 꿈틀거림이 느려져요.
        private const val FRAME_DELAY_MS = 180L

        // 위아래 이동 비율 (1이면 좌우와 같고, 작을수록 위아래가 느려요)
        private const val VERTICAL_RATIO = 0.6f

        // 방향 바꾸는 주기(밀리초)와 한 번에 바꾸는 최대 각도(라디안, 약 55도)
        private const val TURN_MIN_MS = 2000L
        private const val TURN_MAX_MS = 5000L
        private const val TURN_RANGE = 0.95f

        // 방향 전환의 부드러움 (작을수록 천천히 돌아요)
        private const val TURN_EASE = 0.03f
        private const val MAX_TURN_PER_TICK = 0.03f

        // 화면 가장자리에서 방향을 틀기 시작하는 구간 (화면 크기의 비율)
        private const val EDGE_MARGIN = 0.18f

        // 이미지가 뒤집히는 기준
        private const val FLIP_THRESHOLD = 0.25f
    }
}