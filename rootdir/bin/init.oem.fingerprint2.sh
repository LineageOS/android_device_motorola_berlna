#!/vendor/bin/sh
# Determine fingerprint sensor
if [ ! -f /mnt/vendor/persist/fps/vendor_id ];
then
fps_id=$(cat /proc/config/fps_id/ascii)
else
fps_id=$(cat /mnt/vendor/persist/fps/vendor_id)
fi

function set_permissions() {
    if [ "$fps_id" == "chipone" ]
    then
        chmod 0660 /dev/fpsensor
        chown system:system /dev/fpsensor
    elif [ "$fps_id" == "fpc" ]
    then
        chown system:system /sys/class/fingerprint/fpc1020/irq
    elif [ "$fps_id" == "silead" ]
    then
        chmod 0660 /dev/silead_fp
        chown system:system /dev/silead_fp
    elif [ "$fps_id" == "goodix" ]
    then
        chmod 0660 /dev/goodix_fp
        chown system:system /dev/goodix_fp
    elif [ "$fps_id" == "focal" ]
    then
        chmod 0660 /dev/focaltech_fp
        chown system:system /dev/focaltech_fp
    else
        chmod 0660 /dev/esfp0
        chown system:system /dev/esfp0
        chmod 0660 /sys/devices/platform/egis_input/navigation_event
        chown system:system /sys/devices/platform/egis_input/navigation_event
    fi
}

function start_fpsensor() {
    if [ "$fps_id" == "chipone" ]
    then
        insmod /vendor/lib/modules/fpsensor_spi_tee.ko
        sleep 0.6
        set_permissions
        sleep 0.4
        start vendor.chipone_fp_hal
        sleep 1
    elif [ "$fps_id" == "fpc" ]
    then
        insmod /vendor/lib/modules/fpc1020_mmi.ko
        sleep 0.6
        set_permissions
        sleep 0.4
        start vendor.fps_hal
        sleep 1
    elif [ "$fps_id" == "silead" ]
    then
        insmod /vendor/lib/modules/silead_fps_mmi.ko
        sleep 0.6
        set_permissions
        sleep 0.4
        start vendor.silead_hal
        sleep 1
    elif [ "$fps_id" == "goodix" ]
    then
        insmod /vendor/lib/modules/goodix_fod_mmi.ko
        sleep 0.6
        set_permissions
        sleep 0.4
        start vendor.goodix_hal
        sleep 1
    elif [ "$fps_id" == "focal" ]
    then
        insmod /vendor/lib/modules/focal_fps_mmi.ko
        sleep 0.6
        set_permissions
        sleep 0.4
        start vendor.focal_hal
        sleep 1
    else
        insmod /vendor/lib/modules/ets_fps_mmi.ko
        insmod /vendor/lib/modules/rbs_fps_mmi.ko
        insmod /vendor/lib/modules/rbs_fod_mmi.ko
        sleep 0.6
        set_permissions
        sleep 0.4
        start vendor.ets_hal
        sleep 1
    fi
}

rmmod ets_fps_mmi
rmmod rbs_fps_mmi
rmmod rbs_fod_mmi
rmmod fpsensor_spi_tee
rmmod fpc1020_mmi
rmmod goodix_fod_mmi
rmmod silead_fps_mmi
rmmod focal_fps_mmi
stop vendor.ets_hal
stop vendor.focal_hal
stop vendor.goodix_hal
stop vendor.silead_hal
stop vendor.fps_hal
stop vendor.chipone_fp_hal
sleep 0.5
if [ "$fps_id" == "none" ];
then
    fps_id=$(cat /mnt/vendor/persist/fps/last_vendor_id)
fi
start_fpsensor
