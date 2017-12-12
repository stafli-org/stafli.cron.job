
#
#    Debian 8 (jessie) Cron30 Job Scheduler (dockerfile)
#    Copyright (C) 2016-2017 Stafli
#    Luís Pedro Algarvio
#    This file is part of the Stafli Application Stack.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

FROM stafli/stafli.system.base:base10_debian8

#
# Arguments
#

#
# Packages
#

# Install daemon and utilities packages
#  - cron: for crond, the process scheduling daemon
#  - anacron: for anacron, the cron-like program that doesn't go by time
RUN printf "Installing repositories and packages...\n" && \
    \
    printf "Install the required packages...\n" && \
    apt-get update && apt-get install -qy \
      cron anacron && \
    printf "# Cleanup the Package Manager...\n" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    \
    printf "Finished installing repositories and packages...\n";

#
# Configuration
#

# Update daemon configuration
# - Supervisor
# - Cron
RUN printf "Updading Daemon configuration...\n"; \
    \
    printf "Updading Supervisor configuration...\n"; \
    \
    # /etc/supervisor/conf.d/init.conf \
    file="/etc/supervisor/conf.d/init.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# init\n\
[program:init]\n\
command=/bin/bash -c \"supervisorctl start crond;\"\n\
autostart=true\n\
autorestart=false\n\
startsecs=0\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    # /etc/supervisor/conf.d/crond.conf \
    file="/etc/supervisor/conf.d/crond.conf"; \
    printf "\n# Applying configuration for ${file}...\n"; \
    printf "# Cron\n\
[program:crond]\n\
command=/bin/bash -c \"\$(which cron) -f\"\n\
autostart=false\n\
autorestart=true\n\
\n" > ${file}; \
    printf "Done patching ${file}...\n"; \
    \
    printf "Updading Cron configuration...\n"; \
    \
    # ignoring /etc/default/cron \
    touch /etc/crontab; \
    \
    printf "Finished Daemon configuration...\n";

