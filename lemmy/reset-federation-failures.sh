#!/usr/bin/env bash

# pg auth via ~/.pgpass

federation_container_stopped=false

for instance in "$@"
do
        if [[ $instance =~ ^[A-Za-z0-9.-]{5,253}$ ]]
        then
		if [ "$federation_container_stopped" = false ]
		then
			echo "Stopping federation container"
			docker compose stop lemmy_fed_1
			federation_container_stopped=true
		fi

		psql -h localhost -U lemmy_svc -d lemmy << EOF
select instance.updated, federation_queue_state.fail_count
from federation_queue_state
join instance on instance.id = federation_queue_state.instance_id
where instance.domain = '${instance}'
;
EOF

		psql -h localhost -U lemmy_svc -d lemmy << EOF
update federation_queue_state
set fail_count = 0
from instance
where instance.id = federation_queue_state.instance_id
and instance.domain = '${instance}'
;
update instance
set updated = now()
where instance.domain = '${instance}'
;
EOF
        else
                echo "$instance is not a valid domain"
        fi
done

if [ "$federation_container_stopped" = true ]
then
	echo "Restarting federation container"
	docker compose up -d lemmy_fed_1
fi
