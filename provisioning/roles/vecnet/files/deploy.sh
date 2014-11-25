#!/bin/bash

set -x -e

deploy_root=$1
target_dir=$2
rails_env=$3

# do deployment steps

# Copy code to current repo
cp -RPp $deploy_root/shared/cached-copy $target_dir

# Fix permissions
chmod -R 0755 $target_dir
chown -R app:app $target_dir

# link in shared directories

rm -rf -- $target_dir/public/system $target_dir/log $target_dir/tmp/pids
mkdir -p -- $target_dir/public/ $target_dir/tmp/
ln -fs -- $deploy_root/shared/system $target_dir/public/system
ln -fs -- $deploy_root/shared/log $target_dir/log &&
ln -fs -- $deploy_root/shared/pids $target_dir/tmp/pids

# bundle install
cd $target_dir
su app -c "source /etc/profile.d/chruby.sh && chruby 2.0.0-p353 && exec bundle install --gemfile $target_dir/Gemfile --path $deploy_root/shared/bundle --deployment --without development test"

date '+%Y-%m-%d %H:%M:%S' > $target_dir/config/bundle-identifier.txt

# deploy migrate
su app -c "source /etc/profile.d/chruby.sh && chruby 2.0.0-p353 && exec bundle exec rake RAILS_ENV=$rails_env db:migrate"

# deploy precompile
su app -c "source /etc/profile.d/chruby.sh && chruby 2.0.0-p353 && exec bundle exec rake RAILS_ENV=$rails_env RAILS_GROUPS=assets assets:precompile"

# vecnet:write_env_vars
cat > $target_dir/env-vars <<EOS
RAILS_ENV=$rails.env
RAILS_ROOT=$deploy_root/current
EOS

