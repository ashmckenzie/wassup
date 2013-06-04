staging = Host.create(
  label: 'Hotels Staging APP MASTER',
  hostname: 'app_master.hotels_staging_au.ey',
  user: 'deploy',
  keys: [ '/Users/ash/.ssh/jetstar_ey_2048_rsa' ],
  checks: [
    { type: 'disk', config: { disk: '/' } },
    { type: 'process', config: { string: 'nginx', minimum: 1 } },
    { type: 'port', config: { port_number: 81 } }
  ]
)

shrubbery = Host.create(
  label: 'Hotels Shrubbery APP MASTER',
  hostname: 'app_master.hotels_shrubbery.ey',
  user: 'deploy',
  keys: [ '/Users/ash/.ssh/jetstar_ey_2048_rsa' ],
  checks: [
    { type: 'disk', config: { disk: '/' } },
    { type: 'process', config: { string: 'nginx', minimum: 1 } },
    { type: 'port', config: { port_number: 81 } }
  ]
)

mac = Host.create(
  label: 'ash macbook air',
  hostname: 'localhost',
  user: 'ash',
  keys: [ '/Users/ash/.ssh/id_rsa' ],
  checks: [
    { type: 'disk', config: { disk: '/' } },
    { type: 'process', config: { string: 'mysqld', minimum: 1 } },
    { type: 'port', config: { port_number: 3306 } }
  ]
)
