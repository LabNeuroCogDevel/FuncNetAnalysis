AFNIPATH=$(dirname $(which afni))

mnibrain="~/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii"
3dUndump -srad 5 -prefix masks/bb264Mask_MNI -master $mnibrain  -orient LPI -xyz txt/bb264_coords

# via http://afni.nimh.nih.gov/afni/community/board/read.php?1,65877,65878#msg-65878
export AFNI_ANALYZE_ORIENT = LPI
export AFNI_ANALYZE_ORIGINATOR = YES

ls $AFNIPATH/TT_N27+tlrc*
adwarp -resam NN -apar $AFNIPATH/TT_N27+tlrc -dpar masks/bb264Mask_MNI+tlrc -prefix masks/bb264Mask_N27 -force 
3dresample masks/bb264Mask_N27+tlrc 

subjexample=/data/Luna1/Reward/Rest//10152_20100514/afni_restproc/power_nogsr/pm.cleanEPI+tlrc.HEAD
3dresample -master $subjexample -inset masks/bb264Mask_N27+tlrc -prefix masks/bb264Mask_N27_3x3x3
