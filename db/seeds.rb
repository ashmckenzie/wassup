staging = Host.create(
  label: 'Hotels Staging APP MASTER',
  hostname: 'app_master.hotels_staging_au.ey',
  user: 'deploy',
  keys: [ '/Users/ash/.ssh/jetstar_ey_2048_rsa' ]
)

staging.checks = [
  { type: 'disk', config: { disk: '/' } },
  { type: 'process', config: { string: 'nginx', minimum: 1 } },
  { type: 'port', config: { port_number: 81 } },
]

staging.save!

# htpc = Host.create(
#   label: 'HTPC',
#   hostname: 'home',
#   user: 'ash',
#   keys: [ '/Users/ash/.ssh/id_rsa' ]
# )

mac = Host.create(
  label: 'ash macbook air',
  hostname: 'localhost',
  user: 'ash',
  keys: [ '/Users/ash/.ssh/id_rsa' ]
)

mac.checks = [
  { type: 'disk', config: { disk: '/' } },
  { type: 'process', config: { string: 'mysqld', minimum: 1 } },
  { type: 'port', config: { port_number: 3306 } },
]

mac.save!
