# PrivateCloud

Private Cloud Lab

Architecture:

<img width="383" height="272" alt="image" src="https://github.com/user-attachments/assets/8fd024d4-3175-467c-bf9a-93b00f5e8ecf" />

Installation

Topology
LAN изолирована (internal: true). Gateway node выполняет роль маршрутизатора, DNS-сервера и Firewall.
На Docker Desktop полноценный NAT между изолированной сетью и внешней сетью может зависеть от ограничений платформы, поэтому в проекте акцент сделан на архитектуре сети.

Screenshots

Network Diagram

Storage Layer
Ручная настройка NFS подготовлена. Полный запуск rpc.nfsd требует поддержки NFS Server в ядре Linux, которая отсутствует в моем окружении Docker Desktop + WSL2.


Monitoring

Backup
