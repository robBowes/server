# Creates a builder layer to install pnpm then install dependencies and build sveltekit app
# then creates a runtime layer to run the application
# The builder layer is removed after the runtime layer is created
# The runtime layer is the final image

# Builder layer
FROM node:alpine as builder
WORKDIR '/app'
RUN npm install -g pnpm
COPY . .
RUN pnpm install
RUN pnpm exec turbo prune --scope=sveltekit --docker
RUN pnpm run build

# Runtime layer
FROM node:alpine
WORKDIR '/app'
RUN npm install -g pnpm
COPY --from=builder /app/package.json .
RUN pnpm install --production
COPY --from=builder /app/apps/dashboard/build ./build
CMD ["node", "build"]

# docker build -t sveltekit-app .
# docker run -p 3000:3000 sveltekit-app
