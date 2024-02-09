import json

def merge_json(file1, file2):
    with open(file1, 'r', encoding='utf-8') as f1, open(file2, 'r',encoding='utf-8') as f2:
        data1 = json.load(f1)
        data2 = json.load(f2)

    # Merge data2 into data1, overwriting values for common keys
    merged_data = {**data1, **data2}

    return merged_data

# Replace 'file1.json' and 'file2.json' with the actual file paths
file1_path = 'json1.json'
file2_path = 'json2.json'

result = merge_json(file1_path, file2_path,)

# Print the merged result
print(json.dumps(result, indent=4,sort_keys=True))