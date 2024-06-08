# !/bin/bash

CKPT=$1
NUM_FRAMES=$2
MODEL_NAME=$3


if [[ $CKPT == *"ema"* ]]; then
    parentdir=$(dirname $CKPT)
    CKPT_BASE=$(basename $parentdir)_ema
else
    CKPT_BASE=$(basename $CKPT)
fi
LOG_BASE=$(dirname $CKPT)/eval
echo "Logging to $LOG_BASE"

GPUS=(0 1 2 3 4 5 6 7)
TASK_ID_LIST=(4a 4b 4c 4d 4e 4f 4g 4h) # for log records only
START_INDEX_LIST=(0 120 240 360 480 600 720 840)
END_INDEX_LIST=(120 240 360 480 600 720 840 2000)

for i in "${!GPUS[@]}"; do
    CUDA_VISIBLE_DEVICES=${GPUS[i]} bash eval/sample.sh $CKPT ${NUM_FRAMES} ${MODEL_NAME} -4 ${START_INDEX_LIST[i]} ${END_INDEX_LIST[i]}>${LOG_BASE}/${TASK_ID_LIST[i]}.log 2>&1 &
done
