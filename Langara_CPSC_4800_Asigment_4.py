# 1.	Import the NumPy package using the standard alias (np).
# a.	Create a one-dimensional NumPy array with values ranging from 1 to 30.
# b.	Reshape this array into a 5x6 matrix.
# c.	Extract the second column of the matrix.
# d.	Calculate the sum of all the elements in the matrix.

import numpy as np

# a. Create a one-dimensional NumPy array with values ranging from 1 to 30.
d1_array = np.arange(1, 31)
print(d1_array)
print()

# b. Reshape this array into a 5x6 matrix.
d5_6_array = d1_array.reshape(5, 6)
print(d5_6_array)
print()

# c. Extract the second column of the matrix
second_column = d5_6_array[:, 1]
print(second_column)
print()

# d. Calculate the sum of all the elements in the matrix.
matrix_sum = np.sum(d5_6_array)
print(matrix_sum)

# 2.	Create two NumPy arrays: A containing the values [1, 2, 3] and B containing the   values [4, 5, 6].
# a.	Perform the following operations element-wise:
# Addition
# Multiplication
# b.	Find the square of each element in A.
# c.	Calculate the dot product of A and B. Dot product means the sum of the product of A and B element-wise.

d1_array = np.arange(1, 4)
d2_array = np.arange(4, 7)

print("Array A:", d1_array)
print("Array B:", d2_array)

d_sum = d1_array + d2_array
print("Element-wise Addition:", d_sum)
d_sum = np.add(d1_array, d2_array)
print("Element-wise Addition:", d_sum)

d_multiply = d1_array * d2_array
print("Element-wise multiply:", d_multiply)
d_multiply = np.multiply(d1_array, d2_array)
print("Element-wise multiply:", d_multiply)
d_root = np.square(d1_array)
print("Square of each element in A:", d_root)

# c. Calculate the dot product of A and B
dot_product = np.dot(d1_array, d2_array)
# reset
d1_array = np.arange(1, 4)
d2_array = np.arange(4, 7)

print("Dot product of A and B:", dot_product)  # 32

# 3.	Create two 3x3 matrices X and Y with random integer values between 1 and 10.
# Perform the following matrix operations:
# a.	Matrix addition
# b.	Matrix multiplication
# c.	Transpose matrix X.
# d.	Find the determinant of matrix Y.
matrix_1 = np.random.randint(1, 11, (3, 3))
matrix_2 = np.random.randint(1, 11, (3, 3))
print("Matrix X:\n", matrix_1)
print("Matrix Y:\n", matrix_2)

# Manually calculate the determinant of matrix_2
a, b, c = matrix_2[0]
d, e, f = matrix_2[1]
g, h, i = matrix_2[2]

manual_det = a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
print("Manual Determinant of Matrix Y:", manual_det)

# matrix addition
matrix_addition = np.add(matrix_1, matrix_2)
print("Matrix Addition:\n", matrix_addition)

# matrix multiplication (element-wise)
matrix_multiplication = np.multiply(matrix_1, matrix_2)
print("Matrix Multiplication:\n", matrix_multiplication)

# transpose matrix X
matrix_1_transpose = np.transpose(matrix_1)
print("Transpose of Matrix X:\n", matrix_1_transpose)

# determinant of matrix Y
det_matrix_2 = np.linalg.det(matrix_2)
print("Determinant of Matrix Y:", det_matrix_2)

# Pandas (8 marks)
# 4.	Download the Titanic dataset and save it as a CSV file on your local machine.
# The code is provided to you.
# a.	Display the first 10 rows of the dataset.
# b.	Show the column names, data types, and summary statistics for the dataset.

import pandas as pd
df = pd.read_csv('Titanic_Dataset.csv') 

# 5.	Using the Titanic dataset, filter the DataFrame to:
# a.	Display only the rows where passengers are female (Sex column is "female").
# b.	Display only passengers whose age is greater than 30.
# c.	Select and display only the Sex, Age, and Survived columns for passengers who paid a fare greater than 50.


# a. Display only the rows where passengers are female (Sex column is "female").
female_passengers = df[df['Sex'] == 'female']
# print(female_passengers.describe())
print("Female Passengers:\n", female_passengers)

# b. Display only passengers whose age is greater than 30.
age_above_30 = df[df['Age'] > 30]
print("\nPassengers with Age > 30:\n", age_above_30)

# c. Select and display only the Sex, Age, and Survived columns for passengers who paid a fare greater than 50.
high_fare_passengers = df[df['Fare'] > 50][['Sex', 'Age', 'Survived']]
print("\nPassengers with Fare > 50 (Sex, Age, Survived):\n", high_fare_passengers)

# 6.	Group the Titanic dataset by the Pclass (Passenger Class) column and calculate the following:
# a.	The average age of passengers in each class.
# b.	The total number of survivors (Survived column) in each class.
# c.	Create a new DataFrame showing the number of passengers for each combination of Pclass and Sex.

# a. The average age of passengers in each class.
avg_age_by_class = df.groupby('Pclass')['Age'].mean()
print("\nAverage Age by Pclass:\n", avg_age_by_class)

# b.	The total number of survivors (Survived column) in each class.
total_survivors_by_class = df.groupby('Pclass')['Survived'].sum()
print("\nTotal Survivors by Pclass:\n", total_survivors_by_class)

# c.	Create a new DataFrame showing the number of passengers for each combination of Pclass and Sex.
passenger_count_by_class_sex = df.groupby(['Pclass', 'Sex']).size().reset_index(name='PassengerCount')
print("\nPassenger Count by Pclass and Sex:\n", passenger_count_by_class_sex)


# Matplotlib (12 marks)
# 7.	A dataset representing the sales of a company over 12 months (from January to December).
# Create a line plot to visualize the sales data over the months.
# Customize the plot by:
# a.	Adding a title: "Monthly Sales Data"
# b.	Labeling the x-axis as "Month" and the y-axis as "Sales"
# c.	Adding a grid to the plot.

# import matplotlib.pyplot as plt

# # Step 1: Create data for months and sales
# months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
# sales = [1200, 1500, 1700, 1300, 1800, 1600, 1900, 2000, 2100, 2300, 2200, 2500]

import matplotlib.pyplot as plt

# Step 1: Create data for months and sales
months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
sales = [1200, 1500, 1700, 1300, 1800, 1600, 1900, 2000, 2100, 2300, 2200, 2500]

# Create a line plot to visualize the sales data over the months
plt.plot(months, sales, marker='o')
plt.title("Monthly Sales Data")
plt.xlabel("Month")
plt.ylabel("Sales")
plt.grid(True)
plt.show()


# 8.	Create a bar plot to compare the number of students enrolled in different courses: Math, Physics, Computer Science, Biology, and Chemistry.
# Customize the bar plot by:
# a.	Adding a title: "Student Enrollment by Course"
# b.	Labeling the x-axis as "Courses" and the y-axis as "Number of Students"
# c.	Changing the color of the bars.
# d.   Add label on each column value.
# e.   Change color bar per subject or course.

import matplotlib.pyplot as plt

# Step 1: Create data for courses and the number of students
courses = ['Math', 'Physics', 'Computer Science', 'Biology', 'Chemistry']
students = [50, 40, 70, 30, 45]
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']  # Different color for each course

bars = plt.bar(courses, students, color=colors)
plt.title("Student Enrollment by Course")
plt.xlabel("Courses")
plt.ylabel("Number of Students")
plt.grid(True, axis='y')

# Add labels on each bar
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, height + 1, str(height), ha='center', va='bottom')

plt.show()

# 9.	Create a dataset representing the market share of five tech companies: Apple, Google, Microsoft, Amazon, and Facebook.
# Visualize the market share data using a pie chart.
# Customize the pie chart by:
# a. 	Adding percentages to the chart.
# b.	Exploding the slice with the largest market share.
# c.	Adding a title: "Tech Company Market Share".

import matplotlib.pyplot as plt

# Step 1: Create data for tech companies and their market share
companies = ['Apple', 'Google', 'Microsoft', 'Amazon', 'Facebook']
market_share = [30, 25, 20, 15, 10]

# Find the index of the largest market share to explode
explode = [0.1 if share == max(market_share) else 0 for share in market_share]

# Create the pie chart
plt.pie(market_share, labels=companies, autopct='%1.1f%%', explode=explode, shadow=True, startangle=140)
plt.title("Tech Company Market Share")
plt.axis('equal')  # Equal aspect ratio ensures the pie chart is circular.
plt.show()
