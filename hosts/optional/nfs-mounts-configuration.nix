{ config, lib, pkgs, ... }:

{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
  systemd = {
    mounts = let commonMountOptions = {
      type = "nfs";
      mountConfig.Options = "noatime";
    }; in [
      (commonMountOptions // { what = "nas:/mnt/tank/archive"; where = "/srv/nfs/nas/archive"; })
      (commonMountOptions // { what = "nas:/mnt/tank/media/movies"; where = "/srv/nfs/nas/media/movies"; })
      (commonMountOptions // { what = "nas.marisol.home:/mnt/tank/media/music"; where = "/srv/nfs/nas/media/music"; })
      (commonMountOptions // { what = "nas:/mnt/tank/media/shows"; where = "/srv/nfs/nas/media/shows"; })
    ];
    automounts = let commonAutoMountOptions = {
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }; in [
      (commonAutoMountOptions // { where = "/srv/nfs/nas/archive"; })
      (commonAutoMountOptions // { where = "/srv/nfs/nas/media/movies"; })
      (commonAutoMountOptions // { where = "/srv/nfs/nas/media/music"; })
      (commonAutoMountOptions // { where = "/srv/nfs/nas/media/shows"; })
    ];
  };
}
