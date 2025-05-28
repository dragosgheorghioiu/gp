import torch
import torch.nn as nn
import matplotlib.pyplot as plt

class Generator(nn.Module):
    def __init__(self):
        super(Generator, self).__init__()
        self.model = nn.Sequential(
            nn.Linear(100, 256),          # First linear layer (input: 100 -> 256)
            nn.LeakyReLU(0.2),             # Leaky ReLU with a small negative slope
            nn.Linear(256, 512),           # Second linear layer (256 -> 512)
            nn.LeakyReLU(0.2),             # Leaky ReLU
            nn.Linear(512, 1024),          # Third linear layer (512 -> 1024)
            nn.LeakyReLU(0.2),             # Leaky ReLU
            nn.Linear(1024, 64 * 64),      # Final layer (1024 -> 64x64 terrain)
            nn.Tanh()                      # Output activation for pixel values between -1 and 1
        )

    def forward(self, x):
        return self.model(x).view(-1, 64, 64)

if __name__ == '__main__':
    generator = Generator()
    random_input = torch.randn(1, 100)
    generated_terrain = generator(random_input).detach().numpy().reshape(64, 64)

    plt.imshow(generated_terrain, cmap='terrain')
    plt.colorbar(label='Height')
    plt.title('GAN Height Map')
    plt.axis('off')
    plt.show()
