package com.soit.flutter.player.service

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.support.annotation.VisibleForTesting
import com.google.android.exoplayer2.Player
import com.soit.flutter.AppContext
import com.soit.flutter.player.Music
import com.soit.flutter.player.MusicPlayerCallback
import com.soit.flutter.player.QuietMusicPlayer
import java.util.concurrent.atomic.AtomicBoolean

/**
 *
 * the player service which work on Background
 *
 *
 * author : summer
 * date   : 2019/3/1
 */
class PlayerService : Service() {

    companion object {

        /**
         * action skip to play previous
         */
        const val action_play_previous = "previous"

        /**
         * action play when not playing, pause when playing
         */
        const val action_play_pause = "play_pause"

        /**
         * action skip to play next
         */
        const val action_play_next = "next"

        /**
         * action close player
         */
        const val action_exit = "exit"

        /**
         * action add this music to favorite
         */
        const val action_like = "like"

        /**
         * action remove this music from favorite
         */
        const val action_dislike = "dislike"


        /** flag that [PlayerService] is Running */
        private val serviceRunning: AtomicBoolean = AtomicBoolean()


        /**
         * ensure [PlayerService] is Running
         */
        fun ensureServiceRunning(context: Context = AppContext) {
            if (!serviceRunning.get()) {
                context.startService(Intent(context, PlayerService::class.java))
            }
        }

        var notificationHelper: MusicNotification = MusicNotification()
            @VisibleForTesting set

    }

    private val playerServiceBinder = PlayerServiceBinder()

    private val musicPlayer get() = QuietMusicPlayer.getInstance()

    private val callback = object : MusicPlayerCallback {
        override fun onMusicChanged(music: Music?) {
            if (music == null) {
                stopForeground(true)
            }
            notificationHelper.update(this@PlayerService)
        }
    }

    private val playerEventListener = object : Player.EventListener {
        override fun onPlayerStateChanged(playWhenReady: Boolean, playbackState: Int) {
            notificationHelper.update(this@PlayerService)
        }
    }

    override fun onCreate() {
        serviceRunning.set(true)
        super.onCreate()
        musicPlayer.addCallback(callback)
        musicPlayer.addListener(playerEventListener)
        if (musicPlayer.playWhenReady
                && (musicPlayer.playbackState == Player.STATE_READY
                        || musicPlayer.playbackState == Player.STATE_BUFFERING)) {
            ///notification on create when player is playing
            notificationHelper.update(this)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = playerServiceBinder

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        when (action) {
            action_play_previous -> {
                musicPlayer.playPrevious()
            }
            action_play_pause -> {
                musicPlayer.playWhenReady = !(musicPlayer.playWhenReady && musicPlayer.playbackState == Player.STATE_READY)
            }
            action_play_next -> {
                musicPlayer.playNext()
            }
            action_exit -> {
                musicPlayer.removeCallback(callback)
                musicPlayer.removeListener(playerEventListener)
                stopForeground(true)
                stopSelf()
                musicPlayer.release()
            }
            action_like -> {

            }
            action_dislike -> {

            }
        }
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onDestroy() {
        musicPlayer.removeCallback(callback)
        musicPlayer.removeListener(playerEventListener)
        super.onDestroy()
        musicPlayer.release()
        serviceRunning.set(false)
    }


    /**
     * service binder
     */
    inner class PlayerServiceBinder : Binder()


}