-- Research Data Management System (SQL Server)
-- Description: Mock database system for managing lab experiments, researcher contributions, and project analytics

-- dropping existing tables if they exist (for cleaner look and setup)
DROP TABLE IF EXISTS experiment_results;
DROP TABLE IF EXISTS experiments;
DROP TABLE IF EXISTS researcher_projects;
DROP TABLE IF EXISTS researchers;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS labs;


-- 1. creating database schema

-- labs table for research laboratories
CREATE TABLE labs (
    lab_id INT PRIMARY KEY IDENTITY(1,1),
    lab_name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    building VARCHAR(50),
    established_date DATE,
    head_researcher VARCHAR(100)
);

-- researchers table for storing researchers information
CREATE TABLE researchers (
    researcher_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    position VARCHAR(50), -- e.g., 'PhD Student', 'Postdoc', 'PI', 'Research Assistant'
    lab_id INT,
    specialization VARCHAR(100),
    active_status BIT DEFAULT 1,
    FOREIGN KEY (lab_id) REFERENCES labs(lab_id)
);

-- table for research projects
CREATE TABLE projects (
    project_id INT PRIMARY KEY IDENTITY(1,1),
    project_name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    funding_amount DECIMAL(12,2),
    status VARCHAR(20) DEFAULT 'Active', -- 'Active', 'Completed', 'On Hold', 'Cancelled'
    primary_lab_id INT,
    FOREIGN KEY (primary_lab_id) REFERENCES labs(lab_id)
);

-- this table ties researchers to different projects
CREATE TABLE researcher_projects (
    researcher_id INT,
    project_id INT,
    role VARCHAR(50), -- 'Principal Investigator', 'Co-Investigator', 'Research Assistant'
    contribution_percentage DECIMAL(5,2),
    join_date DATE,
    PRIMARY KEY (researcher_id, project_id),
    FOREIGN KEY (researcher_id) REFERENCES researchers(researcher_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- table for individual experiments within projects
CREATE TABLE experiments (
    experiment_id INT PRIMARY KEY IDENTITY(1,1),
    experiment_name VARCHAR(200) NOT NULL,
    project_id INT NOT NULL,
    lead_researcher_id INT,
    experiment_date DATE,
    experiment_type VARCHAR(100), -- e.g., 'Control', 'Treatment', 'Pilot Study'
    hypothesis TEXT,
    methodology TEXT,
    sample_size INT,
    duration_hours DECIMAL(6,2),
    cost DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Planned', -- 'Planned', 'In Progress', 'Completed', 'Failed'
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (lead_researcher_id) REFERENCES researchers(researcher_id)
);

-- storing experimental results and outcomes
CREATE TABLE experiment_results (
    result_id INT PRIMARY KEY IDENTITY(1,1),
    experiment_id INT NOT NULL,
    metric_name VARCHAR(100), -- e.g., 'Success Rate', 'Accuracy', 'Yield', 'Response Time'
    metric_value DECIMAL(15,4),
    unit VARCHAR(20), -- e.g., '%', 'mg', 'seconds', 'units'
    success_indicator BIT, -- 1 for success, 0 for failure
    notes TEXT,
    recorded_date DATETIME DEFAULT GETDATE(),
    recorded_by_researcher_id INT,
    FOREIGN KEY (experiment_id) REFERENCES experiments(experiment_id),
    FOREIGN KEY (recorded_by_researcher_id) REFERENCES researchers(researcher_id)
);



-- 2. mock data

INSERT INTO labs (lab_name, department, building, established_date, head_researcher) VALUES
('Molecular Biology Lab', 'Biology', 'Science Building A','2018-01-15', 'Dr. Sarah Chen'),
('Data Science Lab', 'Computer Science', 'Tech Center','2020-03-10', 'Dr. Michael Rodriguez'),
('Chemistry Research Lab', 'Chemistry', 'Chemical Sciences','2017-09-01', 'Dr. Emily Watson'),
('Physics Lab', 'Physics', 'Physics Building','2015-06-20', 'Dr. James Thompson');

INSERT INTO researchers (first_name, last_name, email, position, lab_id, specialization, active_status) VALUES
('Sarah', 'Chen', 'sarah.chen@university.edu', 'Principal Investigator', 1, 'Molecular Biology', 1),
('Michael', 'Rodriguez', 'michael.rodriguez@university.edu', 'Principal Investigator', 2, 'Machine Learning', 1),
('Emily', 'Watson', 'emily.watson@university.edu', 'Principal Investigator', 3, 'Organic Chemistry', 1),
('James', 'Thompson', 'james.thompson@university.edu', 'Principal Investigator', 4, 'Quantum Physics', 1),
('Alex', 'Johnson', 'alex.johnson@university.edu', 'PhD Student', 1, 'Genetics', 1),
('Maria', 'Garcia', 'maria.garcia@university.edu', 'Postdoc', 2, 'Deep Learning', 1),
('David', 'Kim', 'david.kim@university.edu', 'Research Assistant', 3, 'Analytical Chemistry', 1),
('Lisa', 'Brown', 'lisa.brown@university.edu', 'PhD Student', 4, 'Theoretical Physics', 1),
('John', 'Davis', 'john.davis@university.edu', 'Postdoc', 1, 'Cell Biology', 1),
('Anna', 'Wilson', 'anna.wilson@university.edu', 'Research Assistant', 2, 'Data Analysis', 1);

INSERT INTO projects (project_name, description, start_date, end_date, funding_amount, status, primary_lab_id) VALUES
('Gene Expression Analysis', 'Study of gene expression patterns in cancer cells', '2023-01-01', '2025-12-31', 250000.00, 'Active', 1),
('AI-Powered Drug Discovery', 'Machine learning approaches for pharmaceutical research', '2023-06-01', '2026-05-31', 400000.00, 'Active', 2),
('Sustainable Catalyst Development', 'Development of environmentally friendly catalysts', '2022-09-01', '2024-08-31', 180000.00, 'Active', 3),
('Quantum Computing Applications', 'Exploring quantum algorithms for optimization', '2024-01-01', '2026-12-31', 500000.00, 'Active', 4),
('Protein Folding Dynamics', 'Investigation of protein structure changes', '2023-03-15', '2024-09-30', 150000.00, 'Completed', 1),
('Neural Network Optimization', 'Improving efficiency of deep learning models', '2024-02-01', '2025-01-31', 200000.00, 'Active', 2);

INSERT INTO researcher_projects (researcher_id, project_id, role, contribution_percentage, join_date) VALUES
(1, 1, 'Principal Investigator', 40.0, '2023-01-01'),
(5, 1, 'Research Assistant', 30.0, '2023-01-15'),
(9, 1, 'Co-Investigator', 30.0, '2024-02-01'),
(2, 2, 'Principal Investigator', 50.0, '2023-06-01'),
(6, 2, 'Postdoc', 35.0, '2023-06-15'),
(10, 2, 'Research Assistant', 15.0, '2024-05-15'),
(3, 3, 'Principal Investigator', 60.0, '2022-09-01'),
(7, 3, 'Research Assistant', 40.0, '2023-09-01'),
(4, 4, 'Principal Investigator', 45.0, '2024-01-01'),
(8, 4, 'PhD Student', 55.0, '2024-01-15'),
(1, 5, 'Principal Investigator', 70.0, '2023-03-15'),
(5, 5, 'Research Assistant', 30.0, '2023-03-20'),
(2, 6, 'Principal Investigator', 60.0, '2024-02-01'),
(6, 6, 'Postdoc', 40.0, '2024-02-15');

INSERT INTO experiments (experiment_name, project_id, lead_researcher_id, experiment_date, experiment_type, hypothesis, methodology, sample_size, duration_hours, cost, status) VALUES
('Cancer Cell Gene Expression Test 1', 1, 1, '2023-02-15', 'Treatment', 'Specific genes are overexpressed in cancer cells', 'qPCR analysis of gene expression', 100, 8.0, 2500.00, 'Completed'),
('Cancer Cell Gene Expression Test 2', 1, 5, '2023-03-20', 'Control', 'Normal cells show baseline expression', 'qPCR analysis of gene expression', 100, 8.0, 2500.00, 'Completed'),
('ML Model Training Experiment 1', 2, 2, '2023-07-10', 'Pilot Study', 'Deep learning can predict drug efficacy', 'Neural network training on compound data', 5000, 24.0, 1500.00, 'Completed'),
('ML Model Validation Test', 2, 6, '2023-08-15', 'Treatment', 'Model achieves >90% accuracy on test set', 'Cross-validation on independent dataset', 1000, 4.0, 500.00, 'Completed'),
('Catalyst Efficiency Test 1', 3, 3, '2023-01-10', 'Treatment', 'New catalyst increases reaction yield', 'Comparative analysis of reaction products', 50, 12.0, 3000.00, 'Completed'),
('Catalyst Stability Test', 3, 7, '2023-02-05', 'Treatment', 'Catalyst remains stable under harsh conditions', 'Stress testing under extreme conditions', 25, 48.0, 4000.00, 'Completed'),
('Quantum Algorithm Test 1', 4, 4, '2024-03-01', 'Pilot Study', 'Quantum algorithm outperforms classical', 'Benchmark comparison study', 10, 6.0, 2000.00, 'Completed'),
('Protein Structure Analysis 1', 5, 1, '2023-04-10', 'Treatment', 'Temperature affects protein folding', 'Molecular dynamics simulation', 20, 16.0, 1800.00, 'Completed'),
('Neural Network Pruning Test', 6, 2, '2024-03-15', 'Treatment', 'Pruning reduces model size without accuracy loss', 'Systematic removal of network connections', 500, 12.0, 800.00, 'Completed'),
('Cancer Cell Gene Expression Test 3', 1, 9, '2024-04-20', 'Treatment', 'Treatment affects multiple gene pathways', 'RNA-seq analysis', 150, 10.0, 3500.00, 'Failed'),
('ML Model Optimization Test', 2, 10, '2024-06-01', 'Treatment', 'Hyperparameter tuning improves performance', 'Grid search optimization', 2000, 18.0, 1200.00, 'In Progress'),
('Advanced Catalyst Test', 3, 3, '2024-07-15', 'Treatment', 'Modified catalyst shows improved selectivity', 'Selectivity analysis of reaction products', 40, 20.0, 3800.00, 'Planned');

INSERT INTO experiment_results (experiment_id, metric_name, metric_value, unit, success_indicator, notes, recorded_by_researcher_id) VALUES
(1, 'Gene Expression Fold Change', 3.5, 'fold', 1, 'Significant overexpression detected', 1),
(1, 'Statistical Significance', 0.001, 'p-value', 1, 'Highly significant results', 1),
(2, 'Gene Expression Fold Change', 1.0, 'fold', 1, 'Baseline expression as expected', 5),
(2, 'Statistical Significance', 0.8, 'p-value', 1, 'No significant change from baseline', 5),
(3, 'Model Accuracy', 87.5, '%', 1, 'Good initial performance', 2),
(3, 'Training Time', 18.5, 'hours', 1, 'Reasonable training duration', 2),
(4, 'Model Accuracy', 92.3, '%', 1, 'Exceeded target accuracy', 6),
(4, 'Precision', 90.1, '%', 1, 'High precision achieved', 6),
(4, 'Recall', 94.2, '%', 1, 'Excellent recall performance', 6),
(5, 'Reaction Yield', 78.5, '%', 1, 'Significant improvement over control', 3),
(5, 'Product Purity', 95.2, '%', 1, 'High purity achieved', 3),
(6, 'Catalyst Stability', 89.3, '%', 1, 'Maintained activity after stress test', 7),
(6, 'Activity Retention', 91.7, '%', 1, 'Good stability under harsh conditions', 7),
(7, 'Speedup Factor', 2.8, 'x', 1, 'Notable improvement over classical algorithm', 4),
(7, 'Quantum Advantage', 64.3, '%', 1, 'Clear quantum advantage demonstrated', 4),
(8, 'Folding Accuracy', 82.1, '%', 1, 'Temperature-dependent folding confirmed', 1),
(8, 'Structural Stability', 76.8, '%', 1, 'Moderate stability at higher temperatures', 1),
(9, 'Model Size Reduction', 45.2, '%', 1, 'Significant size reduction achieved', 2),
(9, 'Accuracy Retention', 98.7, '%', 1, 'Minimal accuracy loss', 2),
(10, 'Gene Expression Fold Change', 1.2, 'fold', 0, 'Insufficient expression change detected', 9),
(10, 'Statistical Significance', 0.15, 'p-value', 0, 'Results not statistically significant', 9),
(11, 'Model Accuracy', 89.1, '%', 1, 'Improved performance with tuning', 10),
(11, 'Training Efficiency', 23.5, '%', 1, 'Faster convergence achieved', 10);



-- 3. analysis queries

-- query 1: experiment success rate per project
SELECT 
    p.project_name,
    COUNT(e.experiment_id) as total_experiments,
    SUM(CASE WHEN e.status = 'Completed' THEN 1 ELSE 0 END) as completed_experiments,
    SUM(CASE WHEN e.status = 'Failed' THEN 1 ELSE 0 END) as failed_experiments,
    CAST(SUM(CASE WHEN e.status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.experiment_id) AS DECIMAL(5,2)) as success_rate_percent
FROM projects p
LEFT JOIN experiments e ON p.project_id = e.project_id
GROUP BY p.project_id, p.project_name
ORDER BY success_rate_percent DESC;

-- query 2: analysis of researcher's contributions
SELECT 
    CONCAT(r.first_name, ' ', r.last_name) as researcher_name,
    r.position,
    l.lab_name,
    COUNT(DISTINCT rp.project_id) as projects_involved,
    AVG(rp.contribution_percentage) as avg_contribution_percent,
    COUNT(DISTINCT e.experiment_id) as experiments_led,
    SUM(e.cost) as total_experiment_costs
FROM researchers r
LEFT JOIN researcher_projects rp ON r.researcher_id = rp.researcher_id
LEFT JOIN labs l ON r.lab_id = l.lab_id
LEFT JOIN experiments e ON r.researcher_id = e.lead_researcher_id
WHERE r.active_status = 1
GROUP BY r.researcher_id, r.first_name, r.last_name, r.position, l.lab_name
ORDER BY projects_involved DESC, experiments_led DESC;

-- query 3: analysis of project trends
SELECT 
    YEAR(p.start_date) as project_year,
    COUNT(p.project_id) as projects_started,
    AVG(p.funding_amount) as avg_funding,
    SUM(p.funding_amount) as total_funding,
    COUNT(CASE WHEN p.status = 'Completed' THEN 1 END) as completed_projects,
    COUNT(CASE WHEN p.status = 'Active' THEN 1 END) as active_projects
FROM projects p
GROUP BY YEAR(p.start_date)
ORDER BY project_year DESC;

-- query 4: summary of experimental results
SELECT 
    e.experiment_name,
    p.project_name,
    CONCAT(r.first_name, ' ', r.last_name) as lead_researcher,
    e.experiment_date,
    e.status,
    COUNT(er.result_id) as number_of_metrics,
    AVG(CASE WHEN er.success_indicator = 1 THEN 1.0 ELSE 0.0 END) * 100 as success_percentage,
    e.cost as experiment_cost,
    e.duration_hours
FROM experiments e
JOIN projects p ON e.project_id = p.project_id
JOIN researchers r ON e.lead_researcher_id = r.researcher_id
LEFT JOIN experiment_results er ON e.experiment_id = er.experiment_id
GROUP BY e.experiment_id, e.experiment_name, p.project_name, 
         r.first_name, r.last_name, e.experiment_date, e.status, e.cost, e.duration_hours
ORDER BY e.experiment_date DESC;

-- query 5: research activity (year/month)
SELECT 
    YEAR(e.experiment_date) as year,
    MONTH(e.experiment_date) as month,
    COUNT(e.experiment_id) as experiments_conducted,
    SUM(e.cost) as total_monthly_cost,
    AVG(e.duration_hours) as avg_experiment_duration,
    COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) as completed_experiments,
    COUNT(CASE WHEN e.status = 'Failed' THEN 1 END) as failed_experiments
FROM experiments e
WHERE e.experiment_date IS NOT NULL
GROUP BY YEAR(e.experiment_date), MONTH(e.experiment_date)
ORDER BY year DESC, month DESC;

-- query 6: overall research info
SELECT 
    'Research Overview' as metric_category,
    COUNT(DISTINCT l.lab_id) as total_labs,
    COUNT(DISTINCT r.researcher_id) as total_researchers,
    COUNT(DISTINCT p.project_id) as total_projects,
    COUNT(DISTINCT e.experiment_id) as total_experiments,
    SUM(p.funding_amount) as total_funding,
    AVG(CASE WHEN er.success_indicator = 1 THEN 1.0 ELSE 0.0 END) * 100 as overall_success_rate
FROM labs l
JOIN researchers r ON l.lab_id = r.lab_id
JOIN projects p ON l.lab_id = p.primary_lab_id
JOIN experiments e ON p.project_id = e.project_id
JOIN experiment_results er ON e.experiment_id = er.experiment_id;