import pyaudio
import numpy as np
import matplotlib.pyplot as plt

# Aufnahmeparameter
RATE = 44100         # Sample Rate
CHANNELS = 1         # Mono
FORMAT = pyaudio.paInt16
CHUNK = 1024         # Frames pro Buffer
RECORD_SECONDS = 5   # Länge der Aufnahme

for i in range(0,5):
    OUTPUT_FILE = f"rechtst{i}.npy"

    p = pyaudio.PyAudio()

    # Audio-Stream öffnen
    stream = p.open(format=FORMAT,
                channels=CHANNELS,
                rate=RATE,
                input=True,
                frames_per_buffer=CHUNK)

    print("Aufnahme läuft ...")

    frames = []
    for _ in range(int(RATE / CHUNK * RECORD_SECONDS)):
        data = stream.read(CHUNK)
        frames.append(data)

    print("Aufnahme beendet.")

# Stream schließen
    stream.stop_stream()
    stream.close()
    p.terminate()

    # Byte-Daten zu NumPy-Array (16-bit PCM)
    audio_data = np.frombuffer(b"".join(frames), dtype=np.int16)

    # Als .npy speichern
    np.save(OUTPUT_FILE, audio_data)

    print(f"Gespeichert als {OUTPUT_FILE}")
    plt.plot(range(0, audio_data.size), audio_data)
    plt.show()
print("aufnahme ende")