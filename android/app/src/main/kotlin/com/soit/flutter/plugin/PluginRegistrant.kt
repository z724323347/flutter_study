package com.soit.flutter.plugin

import io.flutter.plugin.common.PluginRegistry

object PluginRegistrant {
    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        DownloadPlugin.registerWith(registry.registrarFor("com.soit.flutter.plugin.DownloadPlugin"))
        NeteaseCryptoPlugin.registerWith(registry.registrarFor("com.soit.flutter.plugin.NeteaseCryptoPlugin"))
        PaletteGeneratorPlugin.registerWith(registry.registrarFor("com.soit.flutter.plugin.PaletteGeneratorPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = PluginRegistrant::class.java.canonicalName
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }

}