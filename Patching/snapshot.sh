#/bin/bash
volume=('vol-0b35b9ed5569f4eae' 'vol-03efc7ba00eb1488e' 'vol-0ac738d0953101894')
i=0
while [ $i -lt ${#volume[@]} ]
do
        echo "Taking Pre-Patching Snapshot of VolumeID: ${volume[$i]}"
        aws ec2 create-snapshot --volume-id ${volume[$i]}
        ((i++))
done
