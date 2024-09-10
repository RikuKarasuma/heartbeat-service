#!/bin/bash


##################################################

test_internet_connection() {

	local target_url="8.8.8.8"

	if ping -c 1 "$target_url" &> /dev/null; then
		echo "Heartbeat: Internet connection up."
		return 1
	else
		echo "Heartbeat: Internet connection down."
		return 0
	fi

}

create_counter() {
	touch ./counter.txt
}

reset_counter() {

	rm ./counter.txt
	create_counter
}

read_counter() {
	return $(<./counter.txt)
}

increment_counter() {

	read_counter
	let old_counter=$?
	echo "Heartbeat: Old counter: "$old_counter
	((old_counter++))
	echo "$old_counter" > ./counter.txt
	echo "Heartbeat: New counter at: "$old_counter
}

is_above_limit() {
	limit=4

	read_counter
	current=$?
	if [ $current -gt $limit ]; then
		return 1
	else
		return 0
	fi
}

##################################################













is_above_limit

if [ $? -eq 1 ]; then
	echo "Heartbeat: Resetting counter"
	reset_counter
	echo "Heartbeat: Restarting..."
	touch ./last_restart
	sudo reboot
else

	test_internet_connection
	let active=$?
	if [ $active -eq 1 ]; then
		reset_counter
		echo "Heartbeat: All OK... sleeping."
	else
		echo "Heartbeat: Unable to reach google DNS, incrementing counter."
		increment_counter
	fi
fi
