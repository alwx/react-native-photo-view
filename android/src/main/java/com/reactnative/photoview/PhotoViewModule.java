package com.reactnative.photoview;

import android.graphics.drawable.Animatable;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.backends.pipeline.PipelineDraweeControllerBuilder;
import com.facebook.drawee.controller.BaseControllerListener;
import com.facebook.imagepipeline.image.ImageInfo;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import me.relex.photodraweeview.PhotoDraweeView;

import javax.annotation.Nullable;

/**
 * @author alwx (http://alwx.me)
 * @version 1.0
 */
public class PhotoViewModule extends SimpleViewManager<PhotoDraweeView> {
    private static final String REACT_CLASS = "PhotoView";

    private ReactApplicationContext mContext;
    private PipelineDraweeControllerBuilder mController;

    public PhotoViewModule(ReactApplicationContext context) {
        mContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected PhotoDraweeView createViewInstance(ThemedReactContext reactContext) {
        return new PhotoDraweeView(reactContext);
    }

    @ReactProp(name = "src")
    public void setSource(final PhotoDraweeView view, @Nullable String source) {
        mController = Fresco.newDraweeControllerBuilder();
        mController.setUri(source);
        mController.setOldController(view.getController());
        mController.setControllerListener(new BaseControllerListener<ImageInfo>() {
            @Override
            public void onFinalImageSet(String id, ImageInfo imageInfo, Animatable animatable) {
                super.onFinalImageSet(id, imageInfo, animatable);
                if (imageInfo == null) {
                    return;
                }
                view.update(imageInfo.getWidth(), imageInfo.getHeight());
            }
        });
        view.setController(mController.build());
    }

}
