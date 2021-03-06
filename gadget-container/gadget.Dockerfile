# Builder: traceloop

# traceloop built from:
# https://github.com/kinvolk/traceloop/commit/0b9f44a1b61b528145f56c8e4b271186be6028f2
# See:
# - https://github.com/kinvolk/traceloop/actions
# - https://hub.docker.com/repository/docker/kinvolk/traceloop/tags

FROM docker.io/kinvolk/traceloop:202005220209060b9f44 as traceloop

# Main gadget image

# BCC built from:
# https://github.com/kinvolk/bcc/commit/32ab858309c84c23049715aaab936ce654ad5792
# See:
# - https://github.com/kinvolk/bcc/actions
# - https://hub.docker.com/repository/docker/kinvolk/bcc/tags

FROM docker.io/kinvolk/bcc:2020052208101032ab85

RUN set -ex; \
	export DEBIAN_FRONTEND=noninteractive; \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates curl

COPY entrypoint.sh /entrypoint.sh
COPY cleanup.sh /cleanup.sh

COPY ocihookgadget/runc-hook-prestart.sh /bin/runc-hook-prestart.sh
COPY ocihookgadget/runc-hook-poststop.sh /bin/runc-hook-poststop.sh
COPY bin/ocihookgadget /bin/ocihookgadget

COPY bin/gadgettracermanager /bin/gadgettracermanager

COPY gadgets/bcck8s /opt/bcck8s
COPY bin/networkpolicyadvisor /bin/networkpolicyadvisor

COPY --from=traceloop /bin/traceloop /bin/traceloop
