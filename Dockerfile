FROM node:18-alpine

# Đặt thư mục làm việc bên trong container
WORKDIR /app
COPY src/package*.json ./

# Cài đặt dependencies
RUN npm i

# Copy toàn bộ code từ thư mục 'src' vào /app
COPY src/ .

# Expose port 3000 (như trong README)
EXPOSE 3000

# Lệnh để chạy ứng dụng khi container khởi động
CMD ["npm", "start"]