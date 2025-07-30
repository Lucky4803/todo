# Base image
FROM node:12.2.0-alpine

# Set working directory
WORKDIR /node

# Copy only package files first (helps caching)
COPY package*.json ./

# Install dependencies (will be cached unless package.json changes)
RUN npm install

# Now copy the rest of the code
COPY . .

# Run tests
RUN npm run test

# Expose the app
EXPOSE 8000

# Start the app
CMD ["node", "app.js"]
