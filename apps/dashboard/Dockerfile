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
RUN pnpm exec turbo prune --scope=dashboard --docker

# Runtime layer
FROM node:alpine as installer
WORKDIR '/app'
RUN npm install -g pnpm
COPY .gitignore .gitignore
RUN mkdir -p ./out/full
COPY --from=builder /app/out/json .
COPY --from=builder /app/out/pnpm-lock.yaml ./pnpm-lock.yaml

# build the project
COPY --from=builder /app/out/full/ .
RUN pnpm install
RUN pnpm --filter dashboard build

FROM node:alpine as runner

WORKDIR '/app'
COPY --from=installer /app/ .
RUN npm install -g pnpm
RUN pnpm install --production
CMD ["node", "./apps/dashboard/build/index.js"]

# docker build -t sveltekit-app .
# docker run -p 3000:3000 sveltekit-app
