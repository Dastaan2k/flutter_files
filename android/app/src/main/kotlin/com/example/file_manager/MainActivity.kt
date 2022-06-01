package com.example.file_manager

import android.app.Activity
import android.app.ActivityManager
import android.os.*
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    private val channel: String = "com.file_manager/channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
                call, result ->
            if(call.method == "getFreeRAM") {
                result.success(getFreeRAM())
            }
            else if(call.method == "getTotalRAM") {
                result.success(getTotalRAM())
            }
            else if(call.method == "getUsedRAM") {
                result.success(getUsedRAM())
            }
            else if(call.method == "getFreeDisk") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
                    result.success(getFreeDisk())
                }
                else {
                    result.error("LOW_SDK_VERSION", "Need SDK version above ${Build.VERSION_CODES.JELLY_BEAN_MR2} to get free disk space", null)
                }
            }
            else if(call.method == "getTotalDisk") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
                    result.success(getTotalDisk())
                }
                else {
                    result.error("LOW_SDK_VERSION", "Need SDK version above ${Build.VERSION_CODES.JELLY_BEAN_MR2} to get total disk space", null)
                }
            }
            else if(call.method == "getUsedDisk") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
                    result.success(getUsedDisk())
                }
                else {
                    result.error("LOW_SDK_VERSION", "Need SDK version above ${Build.VERSION_CODES.JELLY_BEAN_MR2} to get used disk space", null)
                }
            }
            else {
                result.error("UNAVAILABLE", "Unknown method called : " + call.method, null)
            }
        }
    }


    private fun getFreeRAM() : Long {
        val memInfo = ActivityManager.MemoryInfo();
        (getSystemService(ACTIVITY_SERVICE) as ActivityManager).getMemoryInfo(memInfo)
        return memInfo.availMem
    }

    private fun getTotalRAM() : Long {
        val memInfo = ActivityManager.MemoryInfo()
        (getSystemService(ACTIVITY_SERVICE) as ActivityManager).getMemoryInfo(memInfo)
        return memInfo.totalMem
    }

    private fun getUsedRAM() : Long {
        val memInfo = ActivityManager.MemoryInfo()
        (getSystemService(ACTIVITY_SERVICE) as ActivityManager).getMemoryInfo(memInfo)
        return (memInfo.totalMem - memInfo.availMem)
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    private  fun getTotalDisk() : Long {
        val statFs : StatFs = StatFs(Environment.getDataDirectory().absolutePath)
        return statFs.blockCountLong * statFs.blockSizeLong
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    private fun getFreeDisk() : Long {
        val statFs : StatFs = StatFs(Environment.getDataDirectory().absolutePath)
        return statFs.freeBlocksLong * statFs.blockSizeLong
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    private fun getUsedDisk() : Long {
        val statFs : StatFs = StatFs(Environment.getDataDirectory().absolutePath)
        return (statFs.blockCountLong - statFs.freeBlocksLong) * statFs.blockSizeLong
    }

}
