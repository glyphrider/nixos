{ config, lib, pkgs, ... }:

{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
  systemd = {
    mounts = [{
      type = "nfs";
      mountConfig.Options = "noatime";
      what = "nas.marisol.home:/mnt/tank/media/music";
      where = "/srv/nfs/nas/media/music";
    } {
      type = "nfs";
      mountConfig.options = "noatime";
      what = "nas:/mnt/tank/media/movies";
      where = "/srv/nfs/nas/media/movies";
    } {
      type = "nfs";
      mountConfig.options = "noatime";
      what = "nas:/mnt/tank/media/television";
      where = "/srv/nfs/nas/media/television";
    } {
#      type = "nfs";
#      mountConfig.options = "noatime";
#      what = "nas:/mnt/tank/iso";
#      where = "/srv/nfs/nas/iso";
#    } {
      type = "nfs";
      mountConfig.options = "noatime";
      what = "nas:/mnt/tank/archive";
      where = "/srv/nfs/nas/archive";
    }];
    automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
      where = "/srv/nfs/nas/media/music";
    } {
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
      where = "/srv/nfs/nas/media/movies";
    } {
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
      where = "/srv/nfs/nas/media/television";
    } {
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
      where = "/srv/nfs/nas/iso";
    } {
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
      where = "/srv/nfs/nas/archive";
    }];
  };
}
