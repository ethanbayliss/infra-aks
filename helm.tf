resource "helm_release" "vanilla" {
  name       = "vanilla"
  repository = "https://itzg.github.io/minecraft-server-charts/"
  chart      = "itzg/minecraft"

  values = [
    "${file("${path.module}/src/helm/minecraft_vanilla.yml")}"
  ]
}
