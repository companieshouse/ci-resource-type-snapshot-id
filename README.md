# ci-resource-type-snapshot-id

Provides a Concourse-compatible resource type to retrieve EBS Snapshots based on a provided `volume_id`, or retrieve an Snapshot Id when provided with both an `volume_id` and `snapshot_datetime`.

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

* `aws_access_key_id`: *Required.* The AWS access key to use for authentication against the AWS API
* `aws_secret_access_key`: *Required.* The AWS secret access key to use for authentication against the AWS API
* `aws_region`: *Optional* The region in which to perform lookups (Default: `"eu-west-2"`)
* `volume_id`: *Required.* The Id of the EBS Volume to lookups Snapshots for


### Example

With the following resource configuration:

``` yaml
resources:
- name: snapshot-id
  type: ci-resource-type-ami-id
  source:
    aws_access_key_id: <aws_access_key_id>
    aws_secret_access_key: <aws_secret_access_key>
    volume_id: vol-1234567890abcdef
```

Retrieve a Snapshot Id using a `get`

``` yaml
plan:
- get: snapshot-id
- task: a-thing-that-needs-a-snapshot-id
```

## Behavior

### `check`: Report the datetime timestamps of discovered snapshots

Detects new snapshots by querying AWS for all snapshots that originated from the supplied `volume_id` and extracting the datetime of the snapshot.

### `in`: Provide the Snapshot Id to a file

Provides the Snapshot Id to the build as an `snapshot-id` file in the destination.

### `out`: (Disabled)

This feature has been disabled as a precaution because it doesn't support our use case. An error will be returned with a message `This is intended for readonly use only` if invoked.

