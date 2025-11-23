# Titanic Dataset
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd


# Cargar dataset
titanic = sns.load_dataset('titanic')

# Tamaño y tipos de datos
print()
print(titanic.shape)
print()
print(titanic.info())
print()
print(titanic.describe(include='all'))
print()
# questions
#
# can we predict survive based on current information for new data ?
# wicha data columns are correlated
# wicha are the more relevan factor for suvive

# Set style to add grid (cuadricula)
sns.set(style="whitegrid")

# Plot the histogram
ax = sns.histplot(titanic['age'].dropna(), kde=False)

plt.title("Age Distribution")

# Add grid lines (already with whitegrid, but for more control)
plt.grid(True, linestyle='--', linewidth=0.5)

# Annotate bars with their values
for p in ax.patches:
    height = int(p.get_height())
    if height > 0:
        # Place text at the top center of each bar
        ax.annotate(str(height),
                    (p.get_x() + p.get_width() / 2, height),
                    ha='center', va='bottom', fontsize=8, rotation=0)

plt.show()


# Ver valores únicos por columna
for col in titanic.columns:
    print(f"{col}: {titanic[col].unique()[:10]} ...")

# Ver valores nulos
print()
print(titanic.isnull().sum())
print()

# Balance de la variable objetivo
ax = sns.countplot(x='survived', data=titanic)

for p in ax.patches:
    height = int(p.get_height())
    if height > 0:
        # Place text at the top center of each bar
        ax.annotate(str(height),
                    (p.get_x() + p.get_width() / 2, height),
                    ha='center', va='bottom', fontsize=8, rotation=0)
plt.title("¿Está balanceada la supervivencia?")
plt.show()
print("percentages")
print(titanic['survived'].value_counts(normalize=True))


print("counts")
survival_counts = titanic.groupby('sex')['survived'].value_counts()
print(survival_counts)
print(titanic.groupby('sex')['survived'].mean())  #get values by 1 survived
print(titanic.groupby('sex')['survived'].sum())   #get values by 1 survived

# Counts
print()
table = pd.crosstab(titanic['sex'], titanic['survived'])
# Proportion (mean survived)
table['percent_survived'] = (table[1] / (table[0] + table[1]) * 100).round(2)
print("table crosstab")
print(table)
print()

print()
table = pd.crosstab(titanic['pclass'], titanic['survived'])
# Proportion (mean survived)
table['percent_survived'] = (table[1] / (table[0] + table[1]) * 100).round(2)
print("table crosstab")
print(table)
print()


print()
table = pd.crosstab(titanic['fare'], titanic['survived'])
# Proportion (mean survived)
table['percent_survived'] = (table[1] / (table[0] + table[1]) * 100).round(2)
print("table crosstab")
print(table)
print()


# Crea grupos de edad ("bins")
bins = [0, 12, 18, 30, 50, 80]
labels = ['child', 'teen', 'young_adult', 'adult', 'senior']
titanic['age_group'] = pd.cut(titanic['age'], bins=bins, labels=labels)

# Ahora el crosstab será más corto y útil
table = pd.crosstab(titanic['age_group'], titanic['survived'])
table['percent_survived'] = (table[1] / (table[0] + table[1]) * 100).round(2)
print(table)



print()
table = pd.crosstab(titanic['embarked'], titanic['survived'])
# Proportion (mean survived)
table['percent_survived'] = (table[1] / (table[0] + table[1]) * 100).round(2)
print("table crosstab embarked")
print(table)
print()


# Only numeric columns
corr = titanic.corr(numeric_only=True)
plt.figure(figsize=(8,6))
sns.heatmap(corr, annot=True, cmap="coolwarm")
plt.title("Correlation Matrix (Numerical Features)")
plt.show()