package com.root.utils;

public class FrameInfo {
    static {
        System.loadLibrary("frameinfo");
    }

    private long[] frameInfo = new long[14];

    private native void nativeUpdateFrameInfo(long[] frameInfo);

    public void updateFrameInfo() {
        nativeUpdateFrameInfo(frameInfo);
    }

    public double calculateFrameRate() {
        long frameStartTime = frameInfo[2]; 
        long frameEndTime = frameInfo[13];
        double frameDuration = (frameEndTime - frameStartTime) / 1e6;
        return frameDuration > 0 ? 1000.0 / frameDuration : 0.0;
    }
}
