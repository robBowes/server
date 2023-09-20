# Creates a builder layer to install pnpm then install dependencies and build sveltekit app
# then creates a runtime layer to run the application
# The builder layer is removed after the runtime layer is created
# The runtime layer is the final image

# Builder layer
FROM node:alpine as builder
WORKDIR '/app'
RUN npm install -g pnpm
COPY package.json .
RUN pnpm install
COPY . .
RUN pnpm run build

# Runtime layer
FROM node:alpine
WORKDIR '/app'
RUN npm install -g pnpm
COPY --from=builder /app/package.json .
RUN pnpm install --production
COPY --from=builder /app/build ./build
CMD ["node", "build"]

# docker build -t sveltekit-app .
# docker run -p 3000:3000 sveltekit-app
