import platform
import subprocess
from re import split
from math import pow

buf = []

def addData(repeat, value):
	for _ in range(0, repeat):
		buf.append(value & 0xff)
		buf.append(value >> 8)

def toData(note):
	freq = 440 * pow(2, (note - 69) / 12)
	return round(1193182 / freq)

exec = './midi2notes.exe' if platform.system() == 'Windows' else './midi2notes'
process = subprocess.run([exec, 'song.mid'], stdout=subprocess.PIPE)
data = process.stdout.decode('UTF-8').strip()

lastEnd = 0

for line in split(r'\r?\n', data):
	[_, t_start, t_end, t_note] = line.split('\t')
	start = int(t_start)
	end = int(t_end)
	note = int(t_note)
	addData(int((start - lastEnd) / 250), 0)
	addData(int((end - start) / 250), toData(note))
	lastEnd = end

out = open('song.bin', 'wb')
out.write(bytes(buf))
out.close()
