#!/bin/bash
for i in {1..10}
do
	dd if=/dev/zero of="file$i" bs=4K count=1
done
