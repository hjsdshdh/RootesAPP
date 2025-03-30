#include <cstring>
#include <jni.h>
#include <string>

namespace android {
  namespace uirenderer {
    const int UI_THREAD_FRAME_INFO_SIZE = 14;

    class FrameInfo {
    public:
      void importUiThreadInfo(int64_t* info);
      int64_t mFrameInfo[UI_THREAD_FRAME_INFO_SIZE];
    };

    const std::string FrameInfoNames[] = {
      "Flags",
      "IntendedVsync",
      "Vsync",
      "OldestInputEvent",
      "NewestInputEvent",
      "HandleInputStart",
      "AnimationStart",
      "PerformTraversalsStart",
      "DrawStart",
      "SyncQueued",
      "SyncStart",
      "IssueDrawCommandsStart",
      "SwapBuffers",
      "FrameCompleted",
    };

    void FrameInfo::importUiThreadInfo(int64_t* info) {
      memcpy(mFrameInfo, info, UI_THREAD_FRAME_INFO_SIZE * sizeof(int64_t));
    }

    extern "C" JNIEXPORT void JNICALL Java_com_root_utils_FrameInfo_nativeUpdateFrameInfo(JNIEnv* env, jobject obj, jlongArray frameInfo) {
      jlong* info = env->GetLongArrayElements(frameInfo, nullptr);
      FrameInfo frameInfoObj;
      frameInfoObj.importUiThreadInfo(reinterpret_cast<int64_t*>(info));
      env->ReleaseLongArrayElements(frameInfo, info, 0);
    }
  } /* namespace uirenderer */
} /* namespace android */
