import requests

def update_nfs_hosts(base_url, api_key, new_hosts, path_starts_with):
    headers = {'Authorization': f'Bearer {api_key}'}

    # Fetch the current NFS shares
    response = requests.get(f'{base_url}/sharing/nfs', headers=headers)
    response.raise_for_status()
    nfs_shares = response.json()

    for share in nfs_shares:
        # Check if the first item of paths starts with the specified string
        if share['path'].startswith(path_starts_with):
            share_id = share['id']
            updated_data = {'hosts': new_hosts}

            # Update the NFS share
            update_response = requests.put(f'{base_url}/sharing/nfs/id/{share_id}', headers=headers, json=updated_data)
            update_response.raise_for_status()
            print(f'Updated NFS share with ID {share_id}')

# Example usage
base_url = 'https://spitfire.235.tdude.co/api/v2.0'
api_key = '3-EQkuBHti9j66ZIK2aR4Zv6TdZTlOMbEHVTdRomnz2JSiARy2vHt8XgaciLmeYMjT'
new_hosts = [
    "2a10:4741:36:28::5",
    "2a10:4741:36:28::6",
    "2a10:4741:36:28::7",
    "2a0c:9a46:636:28::5",
    "2a0c:9a46:636:28::6",
    "2a0c:9a46:636:28::7",
]
path_starts_with = '/mnt/spitfire-fast/k8s-235/volumes/pvc-'
# path_starts_with = '/mnt/spitfire/k8s-235/volumes/pvc-'
# path_starts_with = '/mnt/spitfire/pomf'

update_nfs_hosts(base_url, api_key, new_hosts, path_starts_with)

