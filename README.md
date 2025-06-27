# Retail-Analytics-for-a-Leading-Chain-Sales-Customer-Insights
📘 Project Overview
This project focuses on retail data analysis for a leading chain in India. The objective was to uncover key customer, sales, and store-level insights from a dataset spanning Sep 2021 to Oct 2023. The data included orders, customers, products, payments, and satisfaction scores from randomly selected stores and customers.

### 🎯 Problem Statement
Conduct in-depth analysis using sales and customer data to address:

👥 Customer Segmentation and purchasing behavior
📈 Sales Trend and Seasonality Analysis across time periods and regions
🔄 Cross-Selling Product Opportunities
😊 Customer Satisfaction insights from review scores
🔁 Cohort Analysis to assess retention patterns
🏪 Store-Level Performance insights by region and product category

### 🧱 Entity Relationship Diagram (ERD)

Data Relationships:
- **Customers → Orders:** One-to-Many  
  *One customer can place multiple orders.*

- **Orders → Stores:** Many-to-One  
  *Each order is associated with one store.*

- **Orders → OrderReviewRatings:** One-to-One  
  *Each order has one corresponding review.*

- **Orders → ProductsInfo:** Many-to-One  
  *Each order item is linked to a single product.*

- **Orders → OrderPayments:** One-to-Many  
  *An order can have multiple payment records (e.g., part payments).*


### 🛠️ Tools & Technologies
MS SQL Server – Data cleaning, joining, and query-based EDA
Excel – Visualizations (trend charts, pivots, cohort analysis)
ER Diagram – Visual schema mapping
GitHub – Code, visuals, and documentation

### 📊 Key Tasks Performed
✔️ Cleaned and joined data from 6+ related tables using SQL
✔️ Created relationships using primary and foreign keys
✔️ Performed EDA to uncover trends by region, time, and product
✔️ Documented findings and uploaded to GitHub 

### 📌 Key Observations & Recommendations (Summary)
📈 Customer Growth Trends: New customer signups peaked in Dec 2022 and Mar 2023; sharp decline in Sep 2023.
➤ Recommendation: Investigate September drop and run acquisition campaigns in low-growth months.

🏪 Sales Insights: In-store shopping dominates; Toys & Gifts is the top revenue category. East and West Bengal underperform.
➤ Recommendation: Promote online channels and boost marketing in low-revenue regions.

🔁 Customer Retention: Repeat buyer revenue peaked in mid-2023 but declined in Sep.
➤ Recommendation: Launch loyalty programs and address retention drop.

💳 Payment & Channel Behavior: Credit Card preferred; UPI and online channels underutilized.
➤ Recommendation: Encourage digital payments and enhance online shopping experience.

📊 Segment Performance: Standard customers contribute over 65% of sales.
➤ Recommendation: Upsell to Silver & Gold segments with exclusive offers.

