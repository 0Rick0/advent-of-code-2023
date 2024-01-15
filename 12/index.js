import {readFile} from 'node:fs/promises';

// const inputFile = 'input.txt';
const inputFile = 'sampleinput.txt';

/**
 * @param input {string}
 * @return {string}
 */
function unfold(input) {
    // ???.### 1,1,3
    // ???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3
    const [pattern, counts] = input.split(' ');
    return Array(5).fill(pattern).join('?') + ' ' + Array(5).fill(counts).join(',');
}

/**
 * @param input {string}
 * @return {Generator<string[], void, *>}
 */
function* permutations(input) {
    /**
     * @type {string[][]}
     */
    const permutable = [];
    for (let string of input.split('')) {
        if (string === '?') {
            permutable.push(['#', '.']);
        } else {
            permutable.push([string])
        }
    }

    function *mapper([current, ...rest]) {
        if (rest.length === 0) {
            for (let string of current) {
                yield [string]
            }
        } else {
            for (let next of mapper(rest)) {
                for (let c of current) {
                    yield [c , ...next];
                }
            }
        }
    }

    yield *mapper(permutable);
}

/**
 * @param springs {string}
 * @return {Generator<number, void, *>}
 */
function* getHotSpringCount(springs) {
    let inBrokenChain = false;
    let brokenCount = 0;
    for (let spring of springs.split('')) {
        if (spring === '#') {
            inBrokenChain = true;
            brokenCount++;
        } else {
            if (inBrokenChain) {
                yield brokenCount;
            }
            brokenCount = 0;
            inBrokenChain = false;
        }
    }
    if (inBrokenChain) {
        yield brokenCount;
    }
}

/**
 * @param permutation {string[]}
 * @param counts {number[]}
 * @return {boolean}
 */
function permutationIsValid(permutation, counts) {
    const parts = permutation
        .join('')
        .split('.')
        .map(x => x.length)
        .filter(x => x !== 0);

    return parts.length === counts.length && counts.every((v, idx) => v === parts[idx]);
}

async function main() {
    /**
     * @type string
     */
    const data = await readFile(inputFile, 'utf-8');
    const lines = data.split('\n').map(line => unfold(line));
    let totalValidPermutations = 0;
    for (let line of lines) {
        let validPermutationsPerLine = 0;
        if (!line.trim()) {
            continue;
        }
        const [pattern, countsString] = line.split(' ');
        const counts = countsString.split(',').map(i => Number.parseInt(i, 10));
        for (let permutation of permutations(pattern)) {
            if (permutationIsValid(permutation, counts)) {
                // console.log(permutation);
                validPermutationsPerLine++;
            }
        }
        console.log('valid permutations for line', line, validPermutationsPerLine);
        totalValidPermutations += validPermutationsPerLine;
    }
    console.log(totalValidPermutations);
}

console.assert(permutationIsValid('.#.#'.split(''), [1, 1]))
console.assert(permutationIsValid('.##.#'.split(''), [2, 1]))
console.assert(permutationIsValid('##.#'.split(''), [2, 1]))

console.assert(unfold('???.### 1,1,3') ==='???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3')

main()
    .catch(error => console.error(error));
