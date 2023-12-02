# Use an official Python runtime as a parent image
FROM ubuntu:20.04 as build

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY module2/.pre-commit-config.yaml /app/.pre-commit-config.yaml
COPY module2/Makefile /app
COPY module2/requirements.txt /app/
COPY module2/resume.yaml /app/
# Copy the .git directory
COPY .git /app/.git

# Set noninteractive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    make \
    python3 \
    python3-venv \
    apt-utils \
    pip \
    git \
    python3-pip \
    libpango-1.0-0 \
    libharfbuzz0b \
    libpangoft2-1.0-0 \
    libffi-dev \
    libjpeg-dev \
    libopenjp2-7-dev && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
# Create a virtual environment
RUN python3 -m venv myenv && \
# Activate the virtual environment
    source myenv/bin/activate && \
    pip install --upgrade pip && \
    # Install any needed packages specified in requirements.txt
    pip install --no-cache-dir -r requirements.txt && \
    # Install pre-commit
    pre-commit install && \
    # Generate resume HTML version
    make export EXT=html

# Set the default command to run when starting the container
CMD ["tail", "-f", "/dev/null"]



# Use a lightweight web server as a parent image
FROM nginx:alpine as web

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Copy the compiled resume files from the first image to the second image
COPY --from=build /app/resume.html /usr/share/nginx/html
#nginx by default serving index.html
RUN mv /usr/share/nginx/html/resume.html /usr/share/nginx/html/index.html

EXPOSE 80

# Define the command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]