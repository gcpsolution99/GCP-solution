# VPC Networking Fundamentals [GSP210]

# Please like, share & subscribe [Abhi Arcade Solution](https://www.youtube.com/channel/UCkk4rjC0a82NRW9nQMohjyQ)

> [!NOTE]
> ***Run Commands in cloud shell:***

```
export ZONE1=
```
```
export ZONE2=
```
```
gcloud compute networks create mynetwork --subnet-mode=auto
gcloud compute instances create mynet-us-vm \
--zone=$ZONE1 \
--machine-type=e2-micro \
--tags=ssh,http,rules \
--network=mynetwork
gcloud compute instances create mynet-second-vm \
--zone=$ZONE1 \
--machine-type=e2-micro \
--tags=ssh,http,rules \
--network=mynetwork
```
