package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.peersafe.edit_exif.FlutterExifPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterExifPlugin.registerWith(registry.registrarFor("com.peersafe.edit_exif.FlutterExifPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
