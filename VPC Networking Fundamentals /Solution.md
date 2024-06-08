# VPC Networking Fundamentals [GSP210](https://www.cloudskillsboost.google/focuses/1229?catalog_rank=%7B%22rank%22%3A1%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=32378824)

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
