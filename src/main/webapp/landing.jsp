<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS - Learn Smarter. Teach Better.</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .landing-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem 4rem;
            max-width: 1300px;
            margin: 0 auto;
        }
        .nav-links {
            display: flex;
            gap: 2rem;
            list-style: none;
        }
        .nav-links a {
            text-decoration: none;
            color: var(--secondary);
            font-weight: 500;
            transition: color 0.2s;
        }
        .nav-links a:hover {
            color: var(--primary);
        }
        .hero-section {
            text-align: center;
            padding: 5rem 1.5rem 4rem;
            max-width: 900px;
            margin: 0 auto;
        }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }
        .hero-title {
            font-size: 3.8rem;
            font-weight: 800;
            letter-spacing: -1.5px;
            line-height: 1.15;
            margin-bottom: 1.25rem;
            background: linear-gradient(135deg, #111827 30%, #2563EB);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-subtitle {
            font-size: 1.2rem;
            color: var(--secondary);
            margin-bottom: 2.5rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        .hero-cta {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 2rem;
            max-width: 1200px;
            margin: 4rem auto 6rem;
            padding: 0 1.5rem;
        }
        .feature-card {
            padding: 2rem;
            background: #FFFFFF;
            border-radius: var(--radius-card);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-soft);
            transition: all 0.2s ease;
        }
        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
        }
        .feature-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: var(--primary-light);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1.25rem;
        }
    </style>
</head>
<body>

    <!-- Landing Header -->
    <nav class="landing-nav">
        <a href="${pageContext.request.contextPath}/" class="sidebar-brand" style="padding: 0; margin: 0;">
            <i class="bi bi-book-half"></i> LMS
        </a>
        <ul class="nav-links">
            <li><a href="#features">Features</a></li>
            <li><a href="${pageContext.request.contextPath}/courses">Courses</a></li>
            <li><a href="#about">About</a></li>
        </ul>
        <div style="display: flex; gap: 1rem; align-items: center;">
            <a href="${pageContext.request.contextPath}/login" class="btn-lms btn-lms-outline">Login</a>
            <a href="${pageContext.request.contextPath}/signup" class="btn-lms btn-lms-primary">Get Started</a>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-badge">
            <i class="bi bi-sparkles"></i> Modern Learning Platform
        </div>
        <h1 class="hero-title">Learn Smarter.<br>Teach Better.</h1>
        <p class="hero-subtitle">Everything you need to manage education in one place — designed for students and educators.</p>

        <div class="hero-cta">
            <a href="${pageContext.request.contextPath}/signup?role=student" class="btn-lms btn-lms-primary" style="padding: 0.9rem 2rem; font-size: 1.05rem;">
                Start Learning <i class="bi bi-arrow-right"></i>
            </a>
            <a href="${pageContext.request.contextPath}/signup?role=instructor" class="btn-lms btn-lms-secondary" style="padding: 0.9rem 2rem; font-size: 1.05rem;">
                Become Instructor
            </a>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" style="max-width: 1200px; margin: 0 auto; padding: 2rem 1.5rem;">
        <div style="text-align: center; margin-bottom: 3rem;">
            <h2 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 0.5rem;">Everything you need to succeed</h2>
            <p style="color: var(--secondary);">Designed with speed, clarity, and precision.</p>
        </div>

        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon"><i class="bi bi-journal-check"></i></div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Assignment Tracking</h3>
                <p style="color: var(--secondary); font-size: 0.95rem;">Clear deadlines, file submissions, automated late policy enforcement, and rubric evaluations.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon" style="background: #ECFDF5; color: var(--accent);"><i class="bi bi-camera-video"></i></div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Live Classes</h3>
                <p style="color: var(--secondary); font-size: 0.95rem;">Integrated lecture video modules, recorded archives, and automated attendance logging.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon" style="background: #FEF3C7; color: var(--warning);"><i class="bi bi-calendar2-check"></i></div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Attendance & Risk Alerts</h3>
                <p style="color: var(--secondary); font-size: 0.95rem;">Real-time attendance trend reporting and predictive risk warnings for students falling behind.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon" style="background: #F3E8FF; color: #9333EA;"><i class="bi bi-cpu"></i></div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">AI Study Assistant</h3>
                <p style="color: var(--secondary); font-size: 0.95rem;">Summarize lecture notes, auto-generate quiz questions, and answer course questions instantly.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon" style="background: #EEF2FF; color: #4F46E5;"><i class="bi bi-bar-chart-line"></i></div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Learning Analytics</h3>
                <p style="color: var(--secondary); font-size: 0.95rem;">Interactive grade distributions, heatmaps, and weekly study hour insights.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon" style="background: #FFF1F2; color: #E11D48;"><i class="bi bi-chat-dots"></i></div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Discussion Forum</h3>
                <p style="color: var(--secondary); font-size: 0.95rem;">Collaborative Q&A channels for peer discussions and instructor announcements.</p>
            </div>
        </div>
    </section>

</body>
</html>
