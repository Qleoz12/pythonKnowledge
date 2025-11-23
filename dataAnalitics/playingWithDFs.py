import pandas as pd

# Create the DataFrame
from sklearn.preprocessing import StandardScaler

df = pd.DataFrame({
    'foo': ['one', 'one', 'one', 'two', 'two', 'two'],
    'bar': ['A', 'B', 'C', 'A', 'B', 'C'],
    'baz': [1, 2, 3, 4, 5, 6],
    'zoo': ['x', 'y', 'z', 'q', 'w', 't']
})

print(df)

df_temp = df.groupby(['foo'])['baz'].mean().reset_index()
print(df_temp)


import numpy as np
import matplotlib.pyplot as plt

# Data
x = np.arange(0, 10, 0.1)
y1 = np.exp(x)
y2 = np.exp(x) / 1.2

# Plot
# plt.plot(x, y1, color='blue', linewidth=3, label='y1')
# plt.plot(x, y2, color='red', linewidth=3, label='y2')
#
# # Labels and title
# plt.xlabel("counting")
# plt.ylabel("testing")
# plt.title("Assignment 2 Q3")

# Legend
plt.legend()

# Show the plot
#plt.show()




# Sample DataFrame with missing values
df = pd.DataFrame({
    'Name': ['Alice', 'Bob', None],
    'Age': [25, None, 30],
    'class': [25, None, None]
})

# Fill missing values with 'Unknown'
df_filled = df.fillna('Unknown')

print(df_filled)

df_filled['class'] = df_filled['class'].replace('Unknown', 'unclassified')

print(df_filled['class'] )
# print(df_filled)



df = pd.DataFrame({
    'Price': np.random.normal(100, 20, 1000)  # 1000 random prices around 100
})

# Histogram plot
# plt.hist(df['Price'], bins=100, color='skyblue', edgecolor='black')
# plt.title('Histogram of Price')
# plt.xlabel('Value $')
# plt.ylabel('Frequency')
# plt.grid(True)
# plt.tight_layout()
# plt.show()

# Create a dummy DataFrame
df = pd.DataFrame({
    'feature1': [10, 20, 30, 40],
    'feature2': [100, 200, 300, 400],
    'label': [0, 1, 0, 1]
})

# Standardize feature1 and feature2
scaler = StandardScaler()
df[['feature1', 'feature2']] = scaler.fit_transform(df[['feature1', 'feature2']])

print(df)