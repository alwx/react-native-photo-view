/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

package com.reactnative.photoview;

import android.support.annotation.IntDef;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class ImageEvent extends Event<ImageEvent> {
  @IntDef({ON_ERROR, ON_LOAD, ON_LOAD_END, ON_LOAD_START, ON_TAP, ON_VIEW_TAP, ON_SCALE})
  @Retention(RetentionPolicy.SOURCE)
  @interface ImageEventType {}

  public static final int ON_ERROR = 1;
  public static final int ON_LOAD = 2;
  public static final int ON_LOAD_END = 3;
  public static final int ON_LOAD_START = 4;
  public static final int ON_TAP = 5;
  public static final int ON_VIEW_TAP = 6;
  public static final int ON_SCALE = 7;

  private final int mEventType;
  private WritableMap mMap;

  public ImageEvent(int viewId, @ImageEventType int eventType) {
    super(viewId);
    mEventType = eventType;
    mMap = null;
  }

  public static String eventNameForType(@ImageEventType int eventType) {
    switch(eventType) {
      case ON_ERROR:
        return "topError";
      case ON_LOAD:
        return "topLoad";
      case ON_LOAD_END:
        return "topLoadEnd";
      case ON_LOAD_START:
        return "topLoadStart";
      case ON_TAP:
        return "topTap";
      case ON_VIEW_TAP:
        return "topViewTap";
      case ON_SCALE:
        return "topScale";
      default:
        throw new IllegalStateException("Invalid image event: " + Integer.toString(eventType));
    }
  }

  @Override
  public String getEventName() {
    return ImageEvent.eventNameForType(mEventType);
  }

  @Override
  public short getCoalescingKey() {
    // Intentionally casting mEventType because it is guaranteed to be small
    // enough to fit into short.
    return (short) mEventType;
  }

  @Override
  public void dispatch(RCTEventEmitter rctEventEmitter) {
    rctEventEmitter.receiveEvent(getViewTag(), getEventName(), mMap);
  }

  public ImageEvent setExtras(WritableMap map){
    this.mMap = map;
    return this;
  }
}
