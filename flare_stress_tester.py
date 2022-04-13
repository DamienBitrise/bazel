import time 
import requests
import subprocess

def trigger_remote_build(commit_hash):
    url = "https://api.bitrise.io/v0.1/apps/6ad72d645b283892/builds"
    data = {
        'hook_info': {
            'type': 'bitrise'
        },
        'build_params': {
            'commit_hash': commit_hash 
        } 
    }
    bitrise_token = ''
    headers = {"Authorization": bitrise_token}
    response = requests.post(url, headers=headers, json=data)
    
    print("Status Code", response.status_code)
    print("JSON Response ", response.json())
    time.sleep(30)

def get_commit_hashes():
    command = ["git", "log", "--oneline"]
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None)
    res_tuple = process.communicate()
    res_bytes = res_tuple[0]
    res_string = res_bytes.decode('utf8')
    commit_list = res_string.splitlines()
    hashes = [str.split(" ")[0] for str in commit_list]
    return hashes

if __name__ == '__main__':
    hashes = get_commit_hashes()
    hash_range = hashes[10:1010]
    
    rev_hashes = [hash for hash in reversed(hash_range)]
    for hash in rev_hashes:
        trigger_remote_build(hash)

