package com.soit.flutter

import android.content.Intent
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.soit.flutter.plugin.PluginRegistrant
import com.soit.flutter.service.PlayerChannel

class MainActivity : FlutterActivity() {

    companion object {


        const val KEY_DESTINATION = "destination"

        const val DESTINATION_PLAYING_PAGE = "action_playing_page"

        const val DESTINATION_DOWNLOAD_PAGE = "action_download_page"

    }

    private lateinit var playerChannel: PlayerChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        PluginRegistrant.registerWith(this)
        playerChannel = PlayerChannel.registerWith(registrarFor("com.soit.flutter.service.PlayerChannel"))
        route(intent)
    }

    override fun onDestroy() {
        playerChannel.destroy()
        super.onDestroy()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        route(intent)
    }

    private fun route(intent: Intent) {
        when (intent.getStringExtra(KEY_DESTINATION)) {
            DESTINATION_PLAYING_PAGE -> {
                flutterView.pushRoute("/playing")
            }
            DESTINATION_DOWNLOAD_PAGE -> {
                flutterView.pushRoute("/downloads")
            }
        }
    }

}
