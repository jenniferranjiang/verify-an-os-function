#include "../../lv_examples.h"
#include <transform.h>
#if LV_USE_IMG && LV_BUILD_EXAMPLES


void lv_example_show(void)
{
    LV_IMG_DECLARE(xiuos);
    lv_obj_t * img1 = lv_img_create(lv_scr_act());
    lv_img_set_src(img1, &xiuos);
    lv_obj_align(img1, LV_ALIGN_CENTER, 0, -20);
    lv_obj_set_size(img1, LVGL_WIDTH, LVGL_HEIGHT);

    lv_obj_t * img2 = lv_img_create(lv_scr_act());
    lv_img_set_src(img2, LV_SYMBOL_OK "Accept");
    lv_obj_align_to(img2, img1, LV_ALIGN_OUT_BOTTOM_MID, 0, 20);
}

#endif
