# ci-resource-type-snapshot-id

Provides a Concourse-compatible resource type to retrieve EBS Snapshots based on a user-definable EBS Volume lookup method, or retrieve an Snapshot Id when provided with both a lookup method and `snapshot_datetime`.

## Installing

Use this resource by adding the following to the `resource_types` section of a pipeline config:

```yaml
resource_types:
- name: ci-resource-type-snapshot-id
  type: docker-image
  source:
    aws_access_key_id: <aws_access_key_id>
    aws_secret_access_key: <aws_secret_access_key>
    repository: <docker-registry>/ci-resource-type-ami-id
    tag: latest
```

## Source Configuration

* `aws_access_key_id`: *Required:* The AWS access key to use for authentication against the AWS API
* `aws_secret_access_key`: *Required:* The AWS secret access key to use for authentication against the AWS API
* `aws_region`: *Optional:* The region in which to perform lookups (Default: `"eu-west-2"`)
* `lookup_method`: *Required:* The lookup method to use - one of [`ec2_tags`, `volume_id`, `volume_tags`]
* `ec2_tags`: *Optional:* Only required when `lookup_method` is set to `ec2_tags`
* `ec2_devicename`: *Optional:* Only required when `lookup_method` is set to `ec2_tags`
* `volume_id`: *Optional:* Only required when `lookup_method` is set to `volume_id`
* `volume_tags`: *Optional:* Only required when `lookup_method` is set to `volume_tags`

## Lookup methods

### ec2_tags

The `ec2_tags` lookup method requires the setting of two additional parameters in the Source configuration

* `ec2_tags`: A comma delimited list of Key=Value pairs used to perform a lookup for an EC2 instance
* `ec2_devicename`: A string specifying the devicename the specific Volume is attached as

With the following resource configuration:

``` yaml
resources:
- name: snapshot-id
  type: ci-resource-type-ami-id
  source:
    aws_access_key_id: <aws_access_key_id>
    aws_secret_access_key: <aws_secret_access_key>
    lookup_method: ec2_tags
    ec2_tags: TagName1=TagValue1,TagName2=TagValue2
    ec2_devicename: /dev/xvdb
```

Retrieve a Snapshot Id using a `get`

``` yaml
plan:
- get: snapshot-id
- task: a-thing-that-needs-a-snapshot-id
```

### volume_id

The `volume_id` lookup method requires the setting of one additional parameter in the Source configuration

* `volume_id`: A string containing an AWS-formatted EBS VolumeId

With the following resource configuration:

``` yaml
resources:
- name: snapshot-id
  type: ci-resource-type-ami-id
  source:
    aws_access_key_id: <aws_access_key_id>
    aws_secret_access_key: <aws_secret_access_key>
    lookup_method: volume_id
    volume_id: vol-1234567890abcdef1
```

Retrieve a Snapshot Id using a `get`

``` yaml
plan:
- get: snapshot-id
- task: a-thing-that-needs-a-snapshot-id
```


### volume_tags

The `volume_tags` lookup method requires the setting of one additional parameter in the Source configuration

* `volume_tags`: A comma delimited list of Key=Value pairs used to perform a lookup for an EC2 instance

With the following resource configuration:

``` yaml
resources:
- name: snapshot-id
  type: ci-resource-type-ami-id
  source:
    aws_access_key_id: <aws_access_key_id>
    aws_secret_access_key: <aws_secret_access_key>
    lookup_method: volume_tags
    volume_tags: TagName1=TagValue1,TagName2=TagValue2
```

Retrieve a Snapshot Id using a `get`

``` yaml
plan:
- get: snapshot-id
- task: a-thing-that-needs-a-snapshot-id
```

## Behavior

### `check`: Report the datetime timestamps of discovered snapshots

Detects new snapshots by querying AWS for all snapshots that originated from the EBS volume identified via the selected lookup method.

### `in`: Provide the Snapshot Id to a file

Provides the Snapshot Id to the build as an `snapshot-id` file in the destination.

### `out`: (Disabled)

This feature has been disabled as a precaution because it doesn't support our use case. An error will be returned with a message `This is intended for readonly use only` if invoked.

