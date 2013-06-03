# staging = Host.create(
#   label: 'hotels_staging_au-app_master',
#   hostname: 'ec2-54-252-88-49.ap-southeast-2.compute.amazonaws.com',
#   user: 'deploy',
#   keys: [ '/Users/ash/.ssh/jetstar_ey_2048_rsa' ]
# )

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
