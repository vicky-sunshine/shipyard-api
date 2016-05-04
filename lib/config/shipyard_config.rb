# Inside are some constant
module ShipyardConfig
  CREATE_TEMPLATE = {
    AttachStdin: false,
    CpuShares: nil,
    Env: [],
    Cmd: [],
    ExposedPorts: {},
    HostConfig: {
      Binds: [],
      Links: [],
      PortBindings: {},
      Privileged: false,
      PublishAllPorts: false,
      RestartPolicy: {
        Name: 'no'
      }
    },
    Image: '',
    Links: [],
    Memory: nil,
    Tty: true,
    Volumes: {}
  }
end
