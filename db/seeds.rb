Host.create(
  label: 'hotels_staging_au-app_master',
  hostname: 'ec2-54-252-88-49.ap-southeast-2.compute.amazonaws.com',
  user: 'deploy',
  keys: [ '/Users/ash/.ssh/jetstar_ey_2048_rsa' ]
)

Host.create(
  label: 'ash macbook air',
  hostname: 'localhost',
  user: 'ash',
  keys: [ '/Users/ash/.ssh/id_rsa' ]
)

Host.create(
  label: 'HTPC',
  hostname: 'home',
  user: 'ash',
  keys: [ '/Users/ash/.ssh/id_rsa' ]
)
