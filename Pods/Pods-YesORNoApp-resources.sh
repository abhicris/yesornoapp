#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@2x.png"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_received.aiff"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_sent.aiff"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Controllers/JSQMessagesViewController.xib"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellIncoming.xib"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellOutgoing.xib"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesLoadEarlierHeaderView.xib"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesToolbarContentView.xib"
install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesTypingIndicatorFooterView.xib"
install_resource "VKFoundation/Assets/VKFoundation_themes.plist"
install_resource "VKFoundation/Assets/VKPickerButton_bg.png"
install_resource "VKFoundation/Assets/VKPickerButton_bg@2x.png"
install_resource "VKFoundation/Assets/VKPickerButton_cross.png"
install_resource "VKFoundation/Assets/VKPickerButton_cross@2x.png"
install_resource "VKFoundation/Assets/VKScrubber_max.png"
install_resource "VKFoundation/Assets/VKScrubber_max@2x.png"
install_resource "VKFoundation/Assets/VKScrubber_min.png"
install_resource "VKFoundation/Assets/VKScrubber_min@2x.png"
install_resource "VKFoundation/Assets/VKScrubber_thumb.png"
install_resource "VKFoundation/Assets/VKScrubber_thumb@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_close.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_close@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_cross.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_cross@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_next.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_next@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_pause.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_pause@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_pause_big.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_pause_big@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_play.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_play@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_play_big.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_play_big@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_rewind.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_rewind@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_zoom_in.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_zoom_in@2x.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_zoom_out.png"
install_resource "VKVideoPlayer/Assets/VKVideoPlayer_zoom_out@2x.png"
install_resource "VKVideoPlayer/Classes/ios/VKVideoPlayerView.xib"
install_resource "VKVideoPlayer/Classes/ios/VKVideoPlayerViewController~ipad.xib"
install_resource "VKVideoPlayer/Classes/ios/VKVideoPlayerViewController~iphone.xib"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
